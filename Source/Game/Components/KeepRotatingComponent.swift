////
///  KeepRotatingComponent.swift
//

class KeepRotatingComponent: ApplyToNodeComponent {
    var rate: CGFloat = 1

    override func update(dt: CGFloat) {
        apply { applyTo in
            applyTo.zRotation = applyTo.zRotation + dt * self.rate
        }
    }

}

extension Node {
    func keepRotating(rate: CGFloat? = nil) -> KeepRotatingComponent {
        let keepRotating = keepRotatingComponent ?? KeepRotatingComponent()
        if let rate = rate {
            keepRotating.rate = rate
        }
        if keepRotatingComponent == nil {
            self.addComponent(keepRotating)
        }
        return keepRotating
    }
}
