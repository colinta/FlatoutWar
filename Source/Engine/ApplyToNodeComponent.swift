////
///  ApplyToNodeComponent.swift
//

class ApplyToNodeComponent: Component {
    private var didSetApplyTo = false
    weak var applyTo: SKNode? {
        didSet {
            didSetApplyTo = true
        }
    }
    override weak var node: Node! {
        didSet {
            if !didSetApplyTo {
                defaultApplyTo()
            }
        }
    }

    func defaultApplyTo() {
        applyTo = node
    }

    func apply(@noescape block: (SKNode) -> Void) {
        if let node = applyTo {
            block(node)
        }
    }

}
