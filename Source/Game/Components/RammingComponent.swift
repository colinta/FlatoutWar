//
//  RammingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class RammingComponent: Component {
    var acceleration: CGFloat = 10
    var currentSpeed: CGFloat?
    var maxSpeed: CGFloat = 25
    var maxTurningSpeed: CGFloat = 10
    var damage: Float = 0
    var target: Node?
    var tempTarget: CGPoint?
    var currentTarget: Node? {
        return target ?? node?.enemyComponent?.currentTarget
    }

    typealias OnRammed = Block
    var _onRammed: [OnRammed] = []
    func onRammed(handler: OnRammed) { _onRammed << handler }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func reset() {
        _onRammed = []
    }

    func removeNodeOnRammed() {
        onRammed {
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    override func update(dt: CGFloat) {
        if let tempTarget = tempTarget
        where tempTarget.distanceTo(node.position, within: 1) {
            self.tempTarget = nil
        }

        // if the node rammed into a target, call the handlers and remove this
        // component (to prevent multiple ramming events)
        if let target = currentTarget
        where node.touches(target)
        {
            for handler in _onRammed {
                handler()
            }
            target.healthComponent?.inflict(damage)
            removeFromNode()
            return
        }

        if let currentTargetLocation = (tempTarget ?? currentTarget?.position) {
            var maxSpeed = self.maxSpeed

            let destAngle: CGFloat
            if let rotateToComponent = node.rotateToComponent {
                rotateToComponent.target = node.position.angleTo(currentTargetLocation)
                if rotateToComponent.isRotating && maxSpeed > maxTurningSpeed {
                    maxSpeed = maxTurningSpeed
                }
                destAngle = node.zRotation
            }
            else {
                node.zRotation = node.position.angleTo(currentTargetLocation)
                destAngle = node.position.angleTo(currentTargetLocation)
            }

            var currentSpeed = self.currentSpeed ?? maxSpeed
            if currentSpeed < maxSpeed {
                currentSpeed += dt * acceleration
                if currentSpeed > maxSpeed {
                    currentSpeed = maxSpeed
                }
            }
            else if currentSpeed > maxSpeed {
                currentSpeed -= dt * acceleration
                if currentSpeed < maxSpeed {
                    currentSpeed = maxSpeed
                }
            }

            let vector = CGPoint(r: currentSpeed, a: destAngle)
            let newCenter = node.position + dt * vector

            self.currentSpeed = currentSpeed
            node.position = newCenter
        }
    }

}
