//
//  RotateToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RotateToComponent: Component {
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

    override func reset() {
    }

    override func update(dt: CGFloat, node: Node) {
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

        if let newAngle = angleTowards(destAngle, fromAngle: currentAngle, by: angularSpeed * dt) {
            self.currentAngle = newAngle
        }
        else {
            self.currentAngle = destAngle
            angularSpeed = 0
        }
    }

}
