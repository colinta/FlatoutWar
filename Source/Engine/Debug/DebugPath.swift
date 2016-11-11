////
///  DebugPath.swift
//

class DebugPath: SKNode {
    var points: [CGPoint] = [] {
        didSet {
            for child in children {
                child.removeFromParent()
            }

            for pt in points {
                let node = SKShapeNode(circleOfRadius: 0.5)
                node.strokeColor = .clear
                node.fillColor = .white
                node.position = pt
                self << node
            }
            index = 0
            current.fillColor = .red
        }
    }

    var index: Int = 0
    var current: SKShapeNode {
        return children[index] as! SKShapeNode
    }

    func next() {
        current.fillColor = .white
        if points.count > 0 {
            index = (index + 1) % points.count
        }
        else {
            index = 0
        }
        current.fillColor = .red
    }
}
