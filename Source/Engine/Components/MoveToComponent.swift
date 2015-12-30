//
//  MoveToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class MoveToComponent: Component {
    var target: CGPoint? {
        didSet {
            if _duration != nil && target != nil {
                _speed = nil
            }
        }
    }
    private var _speed: CGFloat? = CGFloat(100)
    var speed: CGFloat? {
        get { return _speed }
        set {
            _speed = newValue
            _duration = nil
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

    typealias OnArrived = (Node) -> Void
    private var _onArrived = [OnArrived]()
    func onArrived(handler: OnArrived) {
        _onArrived << handler
    }

    override func reset() {
        _onArrived = [OnArrived]()
    }

    override func update(dt: CGFloat, node: Node) {
        guard let target = target else { return }

        let speed: CGFloat
        if let _speed = _speed {
            speed = _speed
        }
        else if let duration = _duration {
            speed = max(0.1, (target - node.position).length / duration)
            _speed = speed
        }
        else {
            return
        }

        if node.position.distanceTo(target, within: dt * speed) {
            node.position = target
            for handler in _onArrived {
                handler(node)
            }
            _onArrived = [OnArrived]()
            self.target = nil
        }
        else {
            let destAngle = node.position.angleTo(target)
            let vector = CGPoint(r: speed, a: destAngle)
            let newCenter = node.position + dt * vector
            node.position = newCenter
        }
    }
}
