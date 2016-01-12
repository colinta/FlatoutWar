//
//  FlyingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FlyingComponent: RammingComponent {
    var currentFlyingTarget: CGPoint? { return flyingTargets.first }
    var flyingTargets: [CGPoint] = []
    override var currentTargetLocation: CGPoint? {
        return tempTarget ?? currentFlyingTarget ?? currentTarget?.position
    }
    override var currentTarget: Node? {
        didSet {
            if let currentTarget = currentTarget {
                var points: [CGPoint] = []
                let dist = currentTarget.distanceTo(node)
                let numTargets: Int = Int(dist / 200)
                let nodeAngle = currentTarget.angleTo(node)
                let segment = dist / CGFloat(numTargets + 1)
                for i in 0..<numTargets {
                    let radius = CGFloat(numTargets - i) * segment ± rand(segment / 4)
                    let angle = nodeAngle ± rand(15.degrees)
                    points << (currentTarget.position + CGPoint(r: radius, a: angle))
                }
                flyingTargets = points
            }
            else {
                flyingTargets = []
            }
        }
    }

    required init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        if let flyingTarget = currentFlyingTarget
        where flyingTarget.distanceTo(node.position, within: 1) {
            self.flyingTargets.removeAtIndex(0)
        }
        super.update(dt)
    }

}
