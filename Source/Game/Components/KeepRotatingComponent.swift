////
///  KeepRotatingComponent.swift
//

class KeepRotatingComponent: ApplyToNodeComponent {
    var rate: CGFloat = 1

    override func update(_ dt: CGFloat) {
        apply { applyTo in
            applyTo.zRotation = applyTo.zRotation + dt * self.rate
        }
    }

}

extension Node {
    @discardableResult
    func keepRotating(_ rate: CGFloat? = nil) -> KeepRotatingComponent {
        let keepRotating = get(component: KeepRotatingComponent.self) ?? KeepRotatingComponent()
        if let rate = rate {
            keepRotating.rate = rate
        }

        addComponent(keepRotating)

        return keepRotating
    }
}
