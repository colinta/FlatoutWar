//
//  MoveToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class MoveToComponent: ApplyToNodeComponent {
    var target: CGPoint? {
        didSet {
            if node != nil {
                currentPosition = node.position
            }

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

    private var currentPosition: CGPoint?

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

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentPosition = node.position
    }

    override func reset() {
        super.reset()
        _onArrived = []
    }

    override func update(dt: CGFloat) {
        guard let target = target else { return }
        guard let currentPosition = currentPosition else { return }

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

        let newPosition: CGPoint
        if currentPosition.distanceTo(target, within: dt * speed) {
            newPosition = target
            for handler in _onArrived {
                handler()
            }
            self.target = nil
        }
        else {
            let destAngle = currentPosition.angleTo(target)
            let vector = CGPoint(r: speed, a: destAngle)
            newPosition = currentPosition + dt * vector
        }
        self.currentPosition = newPosition

        guard let applyTo = applyTo else { return }
        applyTo.position = newPosition
    }
}


extension Node {
    func moveTo(dest: Position, duration: CGFloat? = nil, speed: CGFloat? = nil) -> MoveToComponent {
        let screenSize = world?.screenSize ?? CGSize.Zero
        let position = dest.positionIn(screenSize: screenSize)
        return moveTo(position, duration: duration, speed: speed)
    }

    func moveTo(dest: CGPoint, duration: CGFloat? = nil, speed: CGFloat? = nil) -> MoveToComponent {
        let moveTo = moveToComponent ?? MoveToComponent()
        moveTo.currentPosition = position
        moveTo.target = dest
        moveTo.duration = duration
        moveTo.speed = speed
        moveTo.removeComponentOnArrived()
        if moveToComponent == nil {
            addComponent(moveTo)
        }

        return moveTo
    }
}
