////
///  UINode.swift
//

class UINode: Node {

    override func insertChild(_ node: SKNode, at index: Int) {
        super.insertChild(node, at: index)
        if let node = node as? Node, node.fixedPosition != nil {
            world?.updateFixedNode(node)
        }
    }

}
