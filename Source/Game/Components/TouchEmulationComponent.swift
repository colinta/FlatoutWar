////
///  TouchEmulationComponent.swift
//

class TouchEmulationComponent: Component {
    private var id = NSObject()
    private var currentPosition: CGPoint?
    private var tapPosition: CGPoint?
    private var pressPosition: CGPoint?
    private var savedVector: CGPoint?

    private(set) var touching = false
    private(set) var dragging = false
    private var _targets: [CGPoint] = []
    var targets: [CGPoint] {
        get {
            return _targets
        }
        set {
            if let currentPosition = currentPosition,
                world = node.world
            where _targets.count > 0 {
                touchEnded(world, position: currentPosition)
            }

            if let target = newValue.first where newValue.count == 1 {
                _targets = [target, target]
            }
            else {
                _targets = newValue
            }

            if let first = _targets.first {
                _targets.removeAtIndex(0)
                currentPosition = first
            }
            else {
                currentPosition = nil
            }

            if _duration != nil && _targets.count > 0 {
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

    typealias OnArrived = () -> Void
    private var _onArrived: [OnArrived] = []
    func onArrived(handler: OnArrived) {
        _onArrived << handler
    }

    func removeComponentOnArrived() {
        self.onArrived(removeFromNode)
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

    func tap(position: CGPoint) {
        guard let world = node.world else { return }
        guard !touching && _targets.count == 0 else { fatalError("tap can only be called if targets is empty") }
        touchBegan(world, position: position)
        world.worldTapped(id, worldLocation: position)
        touchEnded(world, position: position)
    }

    func press(position: CGPoint) {
        guard let world = node.world else { return }
        guard !touching && _targets.count == 0 else { fatalError("press can only be called if targets is empty") }
        touchBegan(world, position: position)
        world.worldPressed(id, worldLocation: position)
        touchEnded(world, position: position)
    }

    override func update(dt: CGFloat) {
        guard let currentTarget = targets.first,
            currentPosition = currentPosition,
            world = node.world
        else {
            return
        }

        let speed: CGFloat
        if let _speed = _speed {
            speed = _speed
        }
        else if let duration = _duration {
            var prevPt = currentPosition
            let totalDist = targets.reduce(CGFloat(0)) { dist, pt in
                let total = dist + (pt - prevPt).length
                prevPt = pt
                return total
            }
            speed = max(0.1, totalDist / duration)
            _speed = speed
        }
        else {
            return
        }

        if currentPosition.distanceTo(currentTarget, within: dt * speed) {
            targets.removeAtIndex(0)

            if let nextTarget = targets.first {
                let remTime = dt - currentPosition.distanceTo(currentTarget) / speed
                let destAngle = currentTarget.angleTo(nextTarget)
                let vector = CGPoint(r: speed, a: destAngle)
                let nextPosition = currentTarget + remTime * vector
                touchUpdate(world, position: nextPosition)

                self.currentPosition = nextPosition
                savedVector = vector
            }
            else {
                touchEnded(world, position: currentTarget)

                for handler in _onArrived {
                    handler()
                }

                savedVector = nil
                self.currentPosition = nil
            }
        }
        else {
            let vector: CGPoint
            if let savedVector = savedVector {
                vector = savedVector
            }
            else {
                let destAngle = currentPosition.angleTo(currentTarget)
                vector = CGPoint(r: speed, a: destAngle)
                savedVector = vector
            }

            let newPosition = currentPosition + dt * vector
            touchUpdate(world, position: newPosition)
            self.currentPosition = newPosition
        }
    }

    private func touchUpdate(world: World, position: CGPoint) {
        if !touching {
            touchBegan(world, position: position)
            touching = true
        }
        else {
            dragging = true
            dragBegan(world, position: position)
            dragMoved(world, position: position)
        }
    }

    private func touchBegan(world: World, position: CGPoint) {
        world.worldTouchBegan(id, worldLocation: position)
    }

    private func touchEnded(world: World, position: CGPoint) {
        if dragging {
            dragEnded(world, position: position)
        }
        world.worldTouchEnded(id, worldLocation: position)
        touching = false
        dragging = false
    }

    private func dragBegan(world: World, position: CGPoint) {
        world.worldDraggingBegan(id, worldLocation: position)
    }

    private func dragMoved(world: World, position: CGPoint) {
        world.worldDraggingMoved(id, worldLocation: position)
    }

    private func dragEnded(world: World, position: CGPoint) {
        world.worldDraggingEnded(id, worldLocation: position)
    }

}
