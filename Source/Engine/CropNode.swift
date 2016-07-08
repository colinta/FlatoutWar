////
///  CropNode.swift
//

class CropNode: Node {
    private var skMaskNode = SKCropNode()
    var maskNode: SKNode? {
        get { return skMaskNode.maskNode }
        set { skMaskNode.maskNode = newValue }
    }
    private var maskedNodes: [Node] = []

    required init() {
        super.init()
        self << skMaskNode
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func insertChild(node: SKNode, atIndex index: Int) {
        if let node = node as? Node {
            if index == children.count || index >= skMaskNode.children.count {
                skMaskNode.addChild(node)
            }
            else {
                skMaskNode.insertChild(node, atIndex: index)
            }
            maskedNodes << node
        }
        else {
            super.insertChild(node, atIndex: index)
        }
    }

    override func update(dt: CGFloat) {
        for node in maskedNodes {
            node.update(dt)
        }
    }

}
