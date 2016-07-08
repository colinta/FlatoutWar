////
///  MoveToComponent.swift
//

class MoveToComponent: ApplyToNodeComponent {
    private var resetTarget = false
    var target: CGPoint? {
        didSet {
            resetTarget = false
            if _duration != nil && target != nil {
                _speed = nil
            }
        }
    }

    private var _speed: CGFloat? = 100
    var speed: CGFloat? {
        get { return _speed }
        set {
            _speed = newValue
        }
    }
    private var _duration: CGFloat?
    var duration: CGFloat? {
        get { return _duration }
        set {
            _duration = newValue
            _speed = nil
        }
    }

    private var currentPosition: CGPoint { return node.position }
    private var savedPosition: CGPoint?
    private var savedVector: CGPoint?

    typealias OnArrived = () -> Void
    private var _onArrived: [OnArrived] = []
    func onArrived(handler: OnArrived) {
        _onArrived << handler
    }

    func removeComponentOnArrived() {
        self.onArrived {
            if self.resetTarget {
                self.removeFromNode()
            }
        }
    }

    func removeNodeOnArrived() {
        self.onArrived {
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    func resetOnArrived() {
        self.onArrived {
            self._onArrived = []
        }
    }

    override func reset() {
        super.reset()
        _onArrived = []
    }

    override func update(dt: CGFloat) {
        guard let target = target else { return }

        let speed: CGFloat
        if let _speed = _speed {
            speed = _speed
        }
        else if let duration = _duration {
            speed = max(0.1, (target - currentPosition).length / duration)
            _speed = speed
        }
        else {
            return
        }

        if currentPosition.distanceTo(target, within: dt * speed) {
            apply { applyTo in
                applyTo.position = target
            }

            resetTarget = true
            for handler in _onArrived {
                handler()
            }

            savedVector = nil
            savedPosition = nil
            if resetTarget {
                self.target = nil
            }
        }
        else {
            let vector: CGPoint
            if let savedVector = savedVector, savedPosition = savedPosition
            where savedPosition == target {
                vector = savedVector
            }
            else {
                let destAngle = currentPosition.angleTo(target)
                vector = CGPoint(r: speed, a: destAngle)
                savedVector = vector
                savedPosition = target
            }

            let newPosition = currentPosition + dt * vector
            apply { applyTo in
                applyTo.position = newPosition
            }
        }
    }
}


extension Node {
    func moveTo(dest: Position, duration: CGFloat? = nil, speed: CGFloat? = nil) -> MoveToComponent {
        let screenSize = world!.screenSize
        let position = dest.positionIn(screenSize: screenSize)
        let moveTo = self.moveTo(position, duration: duration, speed: speed)
        moveTo.onArrived {
            self.fixedPosition = dest
        }
        return moveTo
    }

    func moveTo(dest: CGPoint, start: CGPoint? = nil, duration: CGFloat? = nil, speed: CGFloat? = nil, removeNode: Bool = false, removeComponent: Bool = true) -> MoveToComponent {
        let moveTo: MoveToComponent
        if let moveToComponent = moveToComponent {
            moveTo = moveToComponent
            moveTo.resetTarget = false
        }
        else {
            moveTo = MoveToComponent()
        }

        if let start = start {
            self.position = start
        }
        moveTo.target = dest
        if let duration = duration {
            moveTo.duration = duration
        }

        if let speed = speed {
            moveTo.speed = speed
        }

        if removeNode {
            moveTo.removeNodeOnArrived()
        }
        else if removeComponent {
            moveTo.removeComponentOnArrived()
        }

        if moveToComponent == nil {
            addComponent(moveTo)
        }

        return moveTo
    }
}
