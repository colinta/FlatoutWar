//
//  UINode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/31/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class UINode: Node {

    override func insertChild(node: SKNode, atIndex index: Int) {
        super.insertChild(node, atIndex: index)
        if let node = node as? Node where node.fixedPosition != nil {
            world?.updateFixedNode(node)
        }
    }

}
