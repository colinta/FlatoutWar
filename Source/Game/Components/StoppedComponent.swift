////
///  StoppedComponent.swift
//

class StoppedComponent: ApplyToNodeComponent {
    var start: CGPoint?

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func reset() {
        super.reset()
    }

    override func didAddToNode() {
        super.didAddToNode()
        start = node.position
    }

    override func update(_ dt: CGFloat) {
        if let start = start {
            apply { applyTo in
                applyTo.position = start
            }
        }
    }

}
