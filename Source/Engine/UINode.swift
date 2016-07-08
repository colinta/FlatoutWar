////
///  UINode.swift
//

class UINode: Node {

    override func insertChild(node: SKNode, atIndex index: Int) {
        super.insertChild(node, atIndex: index)
        if let node = node as? Node where node.fixedPosition != nil {
            world?.updateFixedNode(node)
        }
    }

}
