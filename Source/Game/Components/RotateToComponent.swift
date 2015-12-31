//
//  RotateToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RotateToComponent: ApplyToNodeComponent {
    var currentAngle: CGFloat?
    var destAngle: CGFloat?
    private(set) var angularSpeed = CGFloat(0)
    var maxAngularSpeed = CGFloat(4)
    // angularAccel is optional, creates a "slow initial spin" effect
    // if it is nil, the maxAngularSpeed is set immediately
    var angularAccel: CGFloat? = CGFloat(3)

    var isRotating: Bool {
        guard let currentAngle = currentAngle, destAngle = destAngle else {
            return false
        }
        return (0.25).degrees < abs(deltaAngle(destAngle, destAngle: currentAngle))
    }

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentAngle = node.zRotation
    }

    override func reset() {
        super.reset()
    }

    override func update(dt: CGFloat) {
        guard let currentAngle = currentAngle, destAngle = destAngle else {
            return
        }

        if let angularAccel = angularAccel {
            angularSpeed += angularAccel * dt
            if angularSpeed > maxAngularSpeed {
                angularSpeed = maxAngularSpeed
            }
        }
        else {
            angularSpeed = maxAngularSpeed
        }

        let newAngle: CGFloat
        if let angle = angleTowards(destAngle, fromAngle: currentAngle, by: angularSpeed * dt) {
            newAngle = angle
        }
        else {
            newAngle = destAngle
            angularSpeed = 0
        }
        self.currentAngle = newAngle

        guard let applyTo = applyTo else { return }
        applyTo.zRotation = newAngle
    }

}
