////
///  KeepMovingComponent.swift
//

class KeepMovingComponent: ApplyToNodeComponent {
    let velocity: CGPoint

    init(velocity: CGPoint) {
        self.velocity = velocity
        super.init()
    }

    required override init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        velocity = coder.decodePoint("velocity") ?? .zero
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        apply { applyTo in
            applyTo.position = applyTo.position + dt * self.velocity
        }
    }

}
