////
///  ApplyToNodeComponent.swift
//

class ApplyToNodeComponent: Component {
    private var didSetApplyTo = false
    weak var applyTo: SKNode? {
        didSet {
            if let node = applyTo {
                initApplyTo(node: node)
            }
            didSetApplyTo = true
        }
    }
    override weak var node: Node! {
        didSet {
            if !didSetApplyTo {
                applyTo = node
            }
        }
    }

    func initApplyTo(node: SKNode) {
    }

    func apply(_ block: (SKNode) -> Void) {
        if let node = applyTo {
            block(node)
        }
    }

}
