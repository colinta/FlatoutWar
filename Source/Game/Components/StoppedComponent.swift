////
///  StoppedComponent.swift
//

class StoppedComponent: ApplyToNodeComponent {
    var start: CGPoint?

    required override init() {
        super.init()
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
