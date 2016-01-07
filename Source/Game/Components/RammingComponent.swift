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
    var currentTargetLocation: CGPoint? {
        return tempTarget ?? target?.position
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
        let targets = node.world?.players ?? target.map { [$0] }
        if let targets = targets,
            struckTarget = (targets.find { $0.playerComponent!.targetable && node.touches($0) })
        {
            for handler in _onRammed {
                handler()
            }
            struckTarget.healthComponent?.inflict(damage)
            removeFromNode()
            return
        }

        if let targetLocation = currentTargetLocation {
            moveTowards(dt, targetLocation)
        }
    }

    func moveTowards(dt: CGFloat, _ targetLocation: CGPoint) {
        var maxSpeed = self.maxSpeed

        let destAngle: CGFloat
        if let rotateToComponent = node.rotateToComponent {
            rotateToComponent.target = node.position.angleTo(targetLocation)
            if rotateToComponent.isRotating {
                maxSpeed = min(maxSpeed, maxTurningSpeed)
            }
            destAngle = rotateToComponent.currentAngle ?? node.zRotation
        }
        else {
            destAngle = node.position.angleTo(targetLocation)
            node.rotateTo(destAngle)
        }

        var currentSpeed = maxSpeed
        if let prevSpeed = self.currentSpeed,
            newSpeed = moveValue(prevSpeed, towards: maxSpeed, by: dt * acceleration)
        {
            currentSpeed = newSpeed
        }

        let vector = CGPoint(r: currentSpeed, a: destAngle)

        let newCenter = node.position + dt * vector
        self.currentSpeed = currentSpeed
        node.position = newCenter
    }

}
