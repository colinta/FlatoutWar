//
//  FollowNodeComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FollowNodeComponent: Component {
    var vector: CGVector?
    var deltaAngle: CGFloat?
    weak var follow: Node?

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func sync(follow: Node) {
        node.position = follow.position
        node.zRotation = follow.zRotation
        self.follow = follow
    }

    override func update(dt: CGFloat) {
        guard let follow = follow else { return }

        let vector: CGVector
        let deltaAngle: CGFloat
        if let _vector = self.vector, _deltaAngle = self.deltaAngle {
            vector = _vector
            deltaAngle = _deltaAngle
        }
        else {
            vector = CGVector(dx: node.position.x - follow.position.x, dy: node.position.y - follow.position.y)
            deltaAngle = node.zRotation - follow.zRotation
            self.vector = vector
            self.deltaAngle = deltaAngle
        }

        node.position = follow.position + vector
        node.zRotation = follow.zRotation + deltaAngle
    }

}
