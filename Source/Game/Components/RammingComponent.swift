//
//  RammingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class RammingComponent: Component {
    var damage: Float = 0
    var currentTarget: Node? {
        return node?.enemyComponent?.currentTarget
    }

    typealias OnRammed = Block
    var _onRammed = [OnRammed]()
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

    var acceleration = CGFloat(10)
    var currentSpeed = CGFloat(0)
    var maxSpeed = CGFloat(25)
    var maxTurningSpeed = CGFloat(10)

    override func reset() {
        _onRammed = [OnRammed]()
    }

    func removeOnRammed() {
        onRammed {
            if let node = self.node {
                node.removeFromParent()
            }
        }
    }

    override func update(dt: CGFloat) {
        // if the node rammed into a target, destroy the node and create an explosion
        if let target = currentTarget {
            if node.touches(target) {
                for handler in _onRammed {
                    handler()
                }
                target.healthComponent?.inflict(damage)
            }
        }

        if let currentTargetLocation = currentTarget?.position {
            var maxSpeed = self.maxSpeed

            let destAngle: CGFloat
            if let rotateToComponent = node.rotateToComponent {
                rotateToComponent.destAngle = node.position.angleTo(currentTargetLocation)
                if rotateToComponent.isRotating && maxSpeed > maxTurningSpeed {
                    maxSpeed = maxTurningSpeed
                }
                destAngle = node.zRotation
            }
            else {
                node.zRotation = node.position.angleTo(currentTargetLocation)
                destAngle = node.position.angleTo(currentTargetLocation)
            }

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

            node.position = newCenter
        }
    }

}
