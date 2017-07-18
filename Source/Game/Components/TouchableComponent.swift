////
///  TouchableComponent.swift
//

class TouchableComponent: Component {
    enum TouchEvent {
        // a quick tap, no dragging
        case tapped
        case tappedInside
        case tappedOutside
        // any length press, no dragging
        case pressed
        case pressedInside
        case pressedOutside
        // drag events
        case dragBegan
        case dragBeganInside
        case dragBeganOutside
        case dragMoved
        case dragEnded
        // generic down/up/move
        case down
        case downInside
        case downOutside
        case up
        case upInside
        case upOutside
        case moved
        case movedInside
        case movedOutside
        // useful for highlight effects
        case enter
        case exit
    }

    enum TouchTestShape {
        case square
        case circle

        var touchTest: TouchTest {
            let minSize: CGFloat = 50
            switch self {
            case .square:
                return { (node, location) in
                    let width = max(minSize, node.size.width)
                    let height = max(minSize, node.size.height)
                    if abs(location.x) <= width / 2 && abs(location.y) <= height / 2 {
                        return true
                    }
                    return false
                }
            case .circle:
                return { (node, location) in
                    let width = max(minSize, node.size.width) / 2
                    let height = max(minSize, node.size.height) / 2
                    return location.lengthWithin(min(width, height))
                }
            }
        }
    }

    typealias OnTouchEvent = (CGPoint) -> Void
    typealias OnDragged = (CGPoint, CGPoint) -> Void
    typealias TouchTest = (Node, CGPoint) -> Bool

    var isIgnoring = false
    var isTouching = false
    var isTouchingInside = false
    var touchedFor: CGFloat = 0
    var prevLocation: CGPoint?
    var touchEvents = [TouchEvent: [OnTouchEvent]]()
    var _onDragged: [OnDragged] = []
    var containsTouchTest: TouchTest?
    var shouldAcceptTouchTest: TouchTest?

    override init() {
        super.init()
    }

    override func reset() {
        super.reset()
        containsTouchTest = nil
        shouldAcceptTouchTest = nil
        touchEvents = [:]
        _onDragged = []
    }

    override func update(_ dt: CGFloat) {
        if isTouching {
            self.touchedFor = touchedFor + dt
        }
    }
}

extension TouchableComponent {

    func tapped(at location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.tapped, location: location)
        if isTouchingInside {
            trigger(.tappedInside, location: location)
        }
        else {
            trigger(.tappedOutside, location: location)
        }
    }

    func pressed(at location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.pressed, location: location)
        if isTouchingInside {
            trigger(.pressedInside, location: location)
        }
        else {
            trigger(.pressedOutside, location: location)
        }
    }

    func touchBegan(at location: CGPoint) {
        isIgnoring = !self.enabled
        guard !isIgnoring else { return }

        isTouchingInside = false
        isTouching = true
        touchedFor = 0

        trigger(.down, location: location)
        trigger(.moved, location: location)

        touchUpdateInOut(at: location)
        if isTouchingInside {
            trigger(.downInside, location: location)
            trigger(.movedInside, location: location)
        }
        else {
            trigger(.downOutside, location: location)
            trigger(.movedOutside, location: location)
        }

        prevLocation = pointInWorld(location)
    }

    func pointInWorld(_ location: CGPoint) -> CGPoint? {
        if let scene = node.scene {
            let sceneLocation = scene.convert(location, from: node)
            return scene.convertPoint(toView: sceneLocation)
        }
        return nil
    }

    func pointInNode(_ location: CGPoint) -> CGPoint? {
        if let scene = node.scene {
            let sceneLocation = scene.convertPoint(fromView: location)
            return scene.convert(sceneLocation, to: node)
        }
        return nil
    }

    func touchEnded(at location: CGPoint) {
        if !isIgnoring {
            if isTouchingInside {
                trigger(.exit, location: location)
                trigger(.upInside, location: location)
            }
            else {
                trigger(.upOutside, location: location)
            }
            trigger(.up, location: location)
        }

        touchedFor = 0
        isIgnoring = false
        isTouching = false
        isTouchingInside = false
        prevLocation = nil
    }

    func touchUpdateInOut(at location: CGPoint) {
        let isInsideNow = containsTouch(at: location)
        if !isTouchingInside && isInsideNow {
            isTouchingInside = true
            trigger(.enter, location: location)
        }
        else if isTouchingInside && !isInsideNow {
            isTouchingInside = false
            trigger(.exit, location: location)
        }
    }

    func draggingBegan(at location: CGPoint) {
        guard !isIgnoring else { return }

        touchUpdateInOut(at: location)
        trigger(.dragBegan, location: location)
        if isTouchingInside {
            trigger(.dragBeganInside, location: location)
        }
        else {
            trigger(.dragBeganOutside, location: location)
        }

        prevLocation = pointInWorld(location)
    }

    func draggingMoved(at location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.moved, location: location)
        trigger(.dragMoved, location: location)

        if let prevLocation = prevLocation,
            let localPoint = pointInNode(prevLocation)
        {
            for handler in _onDragged {
                handler(localPoint, location)
            }
        }

        touchUpdateInOut(at: location)
        if isTouchingInside {
            trigger(.movedInside, location: location)
        }
        else {
            trigger(.movedOutside, location: location)
        }

        prevLocation = pointInWorld(location)
    }

    func draggingEnded(at location: CGPoint) {
        guard !isIgnoring else { return }
        trigger(.dragEnded, location: location)
    }

}

extension TouchableComponent {

    func onDragged(_ handler: @escaping OnDragged) {
        _onDragged << handler
    }
    func offDragged() {
        _onDragged = []
    }

    func off(_ event: TouchEvent) {
        touchEvents[event] = nil
    }

    func on(_ event: TouchEvent, _ handler: @escaping OnTouchEvent) {
        if touchEvents[event] == nil {
            touchEvents[event] = [handler]
        }
        else {
            touchEvents[event]! << handler
        }
    }

    func trigger(_ event: TouchEvent, location: CGPoint) {
        if let handlers = touchEvents[event] {
            for handler in handlers {
                handler(location)
            }
        }
    }

}

extension TouchableComponent {

    class func defaultTouchTest(shape: TouchTestShape = .square) -> TouchTest {
        return shape.touchTest
    }

    func shouldAcceptTouch(at location: CGPoint) -> Bool {
        return shouldAcceptTouchTest?(node, location) ?? true
    }

    func containsTouch(at location: CGPoint) -> Bool {
        guard enabled else { return false }
        return containsTouchTest?(node, location) ?? false
    }

}
