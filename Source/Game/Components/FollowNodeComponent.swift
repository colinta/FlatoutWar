//
//  FollowNodeComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FollowNodeComponent: FollowComponent {
    private var vectorLength: CGFloat?
    private var vectorAngle: CGFloat?
    private var deltaAngle: CGFloat?

    override func didAddToNode() {
        super.didAddToNode()
        guard let follow = follow else { return }

        let vector = node.position - follow.position
        vectorLength = vector.length
        vectorAngle = vector.angle - follow.zRotation
        deltaAngle = node.zRotation - follow.zRotation
    }

    override func update(dt: CGFloat) {
        guard let follow = follow else { return }

        if let vectorLength = vectorLength,
            vectorAngle = vectorAngle,
            deltaAngle = deltaAngle
        {
            let vector = CGPoint(r: vectorLength, a: follow.zRotation + vectorAngle)
            node.position = follow.position + vector
            node.rotateTo(follow.zRotation + deltaAngle)
        }
        else {
            let vector = node.position - follow.position
            vectorLength = vector.length
            vectorAngle = vector.angle - follow.zRotation
            deltaAngle = node.zRotation - follow.zRotation
        }

    }

}
