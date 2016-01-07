//
//  FlyingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FlyingComponent: RammingComponent {
    var currentFlyingTarget: CGPoint? { return flyingTargets.first }
    var flyingTargets: [CGPoint] = []
    override var currentTargetLocation: CGPoint? {
        return tempTarget ?? currentFlyingTarget ?? target?.position
    }
    override var target: Node? {
        didSet {
            if let target = target {
                let numTargets: Int = 2
                var points: [CGPoint] = []
                let dist = target.distanceTo(node)
                let nodeAngle = target.angleTo(node)
                let segment = dist / CGFloat(numTargets + 1)
                for i in 0..<numTargets {
                    let radius = CGFloat(numTargets - i) * segment ± rand(segment / 4)
                    let angle = nodeAngle ± rand((7.5 * CGFloat(numTargets - i)).degrees)
                    points << (target.position + CGPoint(r: radius, a: angle))
                }
                flyingTargets = points
                print("=============== \(__FILE__) line \(__LINE__) ===============\n" +
                      "flyingTargets: \(flyingTargets)")
            }
            else {
                flyingTargets = []
            }
        }
    }

    required init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        if let flyingTarget = currentFlyingTarget
        where flyingTarget.distanceTo(node.position, within: 1) {
            self.flyingTargets.removeAtIndex(0)
        }
        super.update(dt)
    }

    override func moveTowards(dt: CGFloat, _ currentTargetLocation: CGPoint) {
        var maxSpeed = self.maxSpeed

        let destAngle: CGFloat
        if let rotateToComponent = node.rotateToComponent {
            rotateToComponent.target = node.position.angleTo(currentTargetLocation)
            if rotateToComponent.isRotating {
                maxSpeed = min(maxSpeed, maxTurningSpeed)
            }
            destAngle = rotateToComponent.currentAngle ?? node.zRotation
        }
        else {
            destAngle = node.position.angleTo(currentTargetLocation)
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
