//
//  DebugPath.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/28/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DebugPath: SKNode {
    var points: [CGPoint] = [] {
        didSet {
            for child in children {
                child.removeFromParent()
            }

            for pt in points {
                let node = SKShapeNode(circleOfRadius: 0.5)
                node.strokeColor = .clearColor()
                node.fillColor = .whiteColor()
                node.position = pt
                self << node
            }
            index = 0
            current.fillColor = .redColor()
        }
    }

    var index: Int = 0
    var current: SKShapeNode {
        return children[index] as! SKShapeNode
    }

    func next() {
        current.fillColor = .whiteColor()
        if points.count > 0 {
            index = (index + 1) % points.count
        }
        else {
            index = 0
        }
        current.fillColor = .redColor()
    }
}
