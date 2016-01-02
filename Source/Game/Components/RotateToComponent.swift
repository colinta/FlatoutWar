//
//  RotateToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RotateToComponent: ApplyToNodeComponent {
    var currentAngle: CGFloat?
    var target: CGFloat?
    private(set) var angularSpeed: CGFloat = 0
    var maxAngularSpeed: CGFloat = 4
    // angularAccel is optional, creates a "slow initial spin" effect
    // if it is nil, the maxAngularSpeed is set immediately
    var angularAccel: CGFloat? = 3

    var isRotating: Bool {
        guard let currentAngle = currentAngle, target = target else {
            return false
        }
        return (0.25).degrees < abs(deltaAngle(target, target: currentAngle))
    }

    typealias OnRotated = Block
    private var _onRotated: [OnRotated] = []
    func onRotated(handler: OnRotated) {
        if target == nil {
            handler()
        }
        _onRotated << handler
    }

    override func reset() {
        super.reset()
        _onRotated = []
    }

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentAngle = node.zRotation
    }

    override func update(dt: CGFloat) {
        guard let currentAngle = currentAngle, target = target else {
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
        if let angle = moveAngle(currentAngle, towards: target, by: angularSpeed * dt) {
            newAngle = angle
        }
        else {
            newAngle = target
            angularSpeed = 0
            self.target = nil

            for handler in _onRotated {
                handler()
            }
        }
        self.currentAngle = newAngle

        guard let applyTo = applyTo else { return }
        applyTo.zRotation = newAngle
    }

}
