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
        velocity = coder.decodePoint(key: "velocity") ?? .zero
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func update(_ dt: CGFloat) {
        apply { applyTo in
            applyTo.position = applyTo.position + dt * self.velocity
        }
    }

}
