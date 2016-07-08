////
///  RotateToComponent.swift
//

class RotateToComponent: ApplyToNodeComponent {
    var currentAngle: CGFloat?
    var target: CGFloat? {
        didSet {
            if target != nil {
                destAngle = target
            }
        }
    }
    private(set) var destAngle: CGFloat?
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
            angularSpeed = min(angularSpeed + angularAccel * dt, maxAngularSpeed)
        }
        else {
            angularSpeed = maxAngularSpeed
        }

        if let newAngle = moveAngle(currentAngle, towards: target, by: angularSpeed * dt) {
            self.currentAngle = newAngle

            apply { applyTo in
                applyTo.zRotation = newAngle
            }
        }
        else if currentAngle != target {
            apply { applyTo in
                applyTo.zRotation = target
            }

            self.currentAngle = target
        }
        else {
            self.currentAngle = target
            angularSpeed = 0
            self.target = nil

            for handler in _onRotated {
                handler()
            }
        }
    }

}
