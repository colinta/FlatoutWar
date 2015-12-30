//
//  TouchableComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TouchableComponent: Component {
    enum TouchEvent {
        case Tapped
        case Down
        case DownInside
        case Up
        case UpInside
        case Enter
        case Exit
        case Moved
        case DragBegan
        case DragMoved
        case DragEnded
    }

    enum TouchTestShape {
        case Square
        case Circle

        var touchTest: TouchTest {
            switch self {
            case .Square:
                return { (node, location) in
                    if abs(location.x) <= node.size.width / 2 && abs(location.y) <= node.size.height / 2 {
                        return true
                    }
                    return false
                }
            case .Circle:
                return { (node, location) in
                    return location.lengthWithin(min(node.size.width, node.size.height))
                }
            }
        }
    }

    typealias OnTouchEvent = (Node, CGPoint) -> Void
    typealias OnDragged = (Node, CGPoint, CGPoint) -> Void
    typealias OnPressed = (Node, CGPoint, CGFloat) -> Void
    typealias SimpleOnTouchEvent = (CGPoint) -> Void
    typealias SimpleOnDragged = (CGPoint, CGPoint) -> Void
    typealias SimpleOnPressed = (CGPoint, CGFloat) -> Void
    typealias TouchTest = (Node, CGPoint) -> Bool

    var isIgnoring = false
    var isTouching = false
    var isTouchingInside = false
    var touchedFor = CGFloat(0)
    var prevLocation: CGPoint?
    var touchEvents = [TouchEvent: [OnTouchEvent]]()
    var _onDragged = [OnDragged]()
    var _onPressed = [OnPressed]()
    var containsTouchTest: TouchTest?
    var shouldAcceptTouchTest: TouchTest?

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func reset() {
        touchEvents = [:]
        _onDragged = []
        _onPressed = []
    }

    override func update(dt: CGFloat, node: Node) {
        if isTouching {
            self.touchedFor = touchedFor + dt
        }
    }

    func touchBegan(node: Node, location: CGPoint) {
        isIgnoring = !self.enabled
        guard !isIgnoring else { return }

        isTouchingInside = false
        isTouching = true
        touchedFor = 0

        trigger(.Down, node: node, location: location)
        trigger(.Moved, node: node, location: location)

        touchUpdateInOut(node, location: location)
        if isTouchingInside {
            trigger(.DownInside, node: node, location: location)
        }

        prevLocation = location
    }

    func touchEnded(node: Node, location: CGPoint) {
        if !isIgnoring {
            if isTouchingInside {
                trigger(.Exit, node: node, location: location)
                trigger(.UpInside, node: node, location: location)
            }
            trigger(.Up, node: node, location: location)
        }

        isIgnoring = false
        isTouching = false
        isTouchingInside = false
        prevLocation = nil
    }

    func touchUpdateInOut(node: Node, location: CGPoint) {
        let isInsideNow = containsTouch(node, location: location)
        if !isTouchingInside && isInsideNow {
            isTouchingInside = true
            trigger(.Enter, node: node, location: location)
        }
        else if isTouchingInside && !isInsideNow {
            isTouchingInside = false
            trigger(.Exit, node: node, location: location)
        }
    }

    func draggingBegan(node: Node, location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.DragBegan, node: node, location: location)
        touchUpdateInOut(node, location: location)

        prevLocation = location
    }

    func draggingMoved(node: Node, location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Moved, node: node, location: location)
        trigger(.DragMoved, node: node, location: location)

        if let prevLocation = prevLocation {
            for handler in _onDragged {
                handler(node, prevLocation, location)
            }
        }

        touchUpdateInOut(node, location: location)

        prevLocation = location
    }

    func draggingEnded(node: Node, location: CGPoint) {
        guard !isIgnoring else { return }
        trigger(.DragEnded, node: node, location: location)
    }

    func tapped(node: Node, location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Tapped, node: node, location: location)
    }

    func pressed(node: Node, location: CGPoint, duration: CGFloat) {
        guard !isIgnoring else { return }

        for handler in _onPressed {
            handler(node, location, duration)
        }
    }

}

extension TouchableComponent {

    func onDraggedNode(handler: OnDragged) {
        _onDragged << handler
    }

    func onDragged(handler: SimpleOnDragged) {
        _onDragged << { (_, prevLocation, location) in handler(prevLocation, location) }
    }

    func onPressedNode(handler: OnPressed) {
        _onPressed << handler
    }

    func onPressed(handler: SimpleOnPressed) {
        _onPressed << { (_, location, duration) in handler(location, duration) }
    }

    func on(event: TouchEvent, _ handler: SimpleOnTouchEvent) {
        self.on(event, { _, location in handler(location) })
    }

    func on(event: TouchEvent, _ handler: OnTouchEvent) {
        if touchEvents[event] == nil {
            touchEvents[event] = [handler]
        }
        else {
            touchEvents[event]! << handler
        }
    }

    func trigger(event: TouchEvent, node: Node, location: CGPoint) {
        if let handlers = touchEvents[event] {
            for handler in handlers {
                handler(node, location)
            }
        }
    }

}

extension TouchableComponent {

    class func defaultTouchTest(shape: TouchTestShape = .Square) -> TouchTest {
        return shape.touchTest
    }


    func shouldAcceptTouch(node: Node, location: CGPoint) -> Bool {
        return shouldAcceptTouchTest?(node, location) ?? true
    }

    func containsTouch(node: Node, location: CGPoint) -> Bool {
        guard enabled else { return false }
        return containsTouchTest?(node, location) ?? false
    }

}
