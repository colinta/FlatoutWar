//
//  TargetingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TargetingComponent: Component {
    var radius: CGFloat?
    var sweepAngle: CGFloat?
    var currentTarget: Node? {
        didSet {
            currentTargetVector = nil
            currentTargetPrevLocation = nil
        }
    }
    var reallySmart = false
    var bulletSpeed: CGFloat?
    var currentTargetVector: CGPoint?
    var currentTargetPrevLocation: CGPoint?

    override func reset() {
        currentTarget = nil
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat, node: Node) {
        if let enemy = currentTarget
            where !isViableTarget(node, enemy: enemy)
        {
            currentTarget = nil
        }

        let isRotating = node.rotateToComponent?.isRotating ?? false
        if let world = node.world where currentTarget == nil && !isRotating {
            acquireTarget(node, world: world)
        }

        if let prevLocation = currentTargetPrevLocation, currentLocation = currentTarget?.position {
            currentTargetVector = (currentLocation - prevLocation) / dt
        }

        currentTargetPrevLocation = currentTarget?.position
    }

    func isViableTarget(node: Node, enemy: Node) -> Bool {
        guard let world = node.world
            where world.enemies.contains(enemy) else
        {
            return false
        }
        guard let radius = radius else {
            return false
        }
        let enemyPosition = node.convertPoint(CGPointZero, fromNode: enemy)
        guard enemyPosition.lengthWithin(radius) else
        {
            return false
        }

        // no sweepAngle means 360° targeting
        guard let sweepAngle = sweepAngle else { return true }

        let angle = enemyPosition.angle
        let normalized = deltaAngle(angle, destAngle: node.zRotation)
        let sweep: CGFloat
        let reallyCloseAdjustment = CGFloat(40)
        if enemyPosition.lengthWithin(reallyCloseAdjustment) {
            sweep = sweepAngle + 20.degrees
        }
        else {
            sweep = sweepAngle
        }
        return abs(normalized) <= sweep / 2.0
    }

    func angleToTarget(node: Node) -> CGFloat? {
        if let currentTarget = currentTarget {
            if reallySmart {
                if let currentVector = currentTargetVector,
                    bulletSpeed = bulletSpeed
                {
                    let time = node.distanceTo(currentTarget) / bulletSpeed
                    let predictedPosition = currentVector * time
                    let relativePosition = node.convertPoint(predictedPosition, fromNode: currentTarget)
                    return relativePosition.angle
                }
                return nil
            }

            return node.angleTo(currentTarget)
        }
        return nil
    }

    private func acquireTarget(node: Node, world: World) {
        if let currentTarget = currentTarget
        where currentTarget.world != node.world
        {
            self.currentTarget = nil
        }

        var bestTarget: Node? = currentTarget
        var bestDistance = CGFloat(0)

        for enemy in world.enemies {
            if isViableTarget(node, enemy: enemy) {
                let enemyPosition = node.convertPoint(CGPointZero, fromNode: enemy)
                let enemyDistance = enemyPosition.roughLength

                if bestTarget == nil {
                    bestTarget = enemy
                    bestDistance = enemyDistance
                }
                else if enemyDistance < bestDistance {
                    bestTarget = enemy
                    bestDistance = enemyDistance
                }
            }
        }

        currentTarget = bestTarget
    }

}
