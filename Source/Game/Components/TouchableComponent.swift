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

    typealias OnTouchEvent = (CGPoint) -> Void
    typealias OnDragged = (CGPoint, CGPoint) -> Void
    typealias OnPressed = (CGPoint, CGFloat) -> Void
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
        super.reset()
        touchEvents = [:]
        _onDragged = []
        _onPressed = []
    }

    override func update(dt: CGFloat) {
        if isTouching {
            self.touchedFor = touchedFor + dt
        }
    }

    func touchBegan(location: CGPoint) {
        isIgnoring = !self.enabled
        guard !isIgnoring else { return }

        isTouchingInside = false
        isTouching = true
        touchedFor = 0

        trigger(.Down, location: location)
        trigger(.Moved, location: location)

        touchUpdateInOut(location)
        if isTouchingInside {
            trigger(.DownInside, location: location)
        }

        prevLocation = location
    }

    func touchEnded(location: CGPoint) {
        if !isIgnoring {
            if isTouchingInside {
                trigger(.Exit, location: location)
                trigger(.UpInside, location: location)
            }
            trigger(.Up, location: location)
        }

        isIgnoring = false
        isTouching = false
        isTouchingInside = false
        prevLocation = nil
    }

    func touchUpdateInOut(location: CGPoint) {
        let isInsideNow = containsTouch(location)
        if !isTouchingInside && isInsideNow {
            isTouchingInside = true
            trigger(.Enter, location: location)
        }
        else if isTouchingInside && !isInsideNow {
            isTouchingInside = false
            trigger(.Exit, location: location)
        }
    }

    func draggingBegan(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.DragBegan, location: location)
        touchUpdateInOut(location)

        prevLocation = location
    }

    func draggingMoved(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Moved, location: location)
        trigger(.DragMoved, location: location)

        if let prevLocation = prevLocation {
            for handler in _onDragged {
                handler(prevLocation, location)
            }
        }

        touchUpdateInOut(location)

        prevLocation = location
    }

    func draggingEnded(location: CGPoint) {
        guard !isIgnoring else { return }
        trigger(.DragEnded, location: location)
    }

    func tapped(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Tapped, location: location)
    }

    func pressed(location: CGPoint, duration: CGFloat) {
        guard !isIgnoring else { return }

        for handler in _onPressed {
            handler(location, duration)
        }
    }

}

extension TouchableComponent {

    func onDragged(handler: OnDragged) {
        _onDragged << handler
    }

    func onPressed(handler: OnPressed) {
        _onPressed << handler
    }

    func on(event: TouchEvent, _ handler: OnTouchEvent) {
        if touchEvents[event] == nil {
            touchEvents[event] = [handler]
        }
        else {
            touchEvents[event]! << handler
        }
    }

    func trigger(event: TouchEvent, location: CGPoint) {
        if let handlers = touchEvents[event] {
            for handler in handlers {
                handler(location)
            }
        }
    }

}

extension TouchableComponent {

    class func defaultTouchTest(shape: TouchTestShape = .Square) -> TouchTest {
        return shape.touchTest
    }


    func shouldAcceptTouch(location: CGPoint) -> Bool {
        return shouldAcceptTouchTest?(node, location) ?? true
    }

    func containsTouch(location: CGPoint) -> Bool {
        guard enabled else { return false }
        return containsTouchTest?(node, location) ?? false
    }

}
