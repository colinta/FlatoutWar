//
//  ResourceNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/12/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

protocol ResourceWorld: class {
    func playerFoundResource(resourceNode: ResourceNode)
}

private let InitialDecay: CGFloat = 2

class ResourceNode: Node {
    var locked = false
    var decay = InitialDecay
    let sprite = SKSpriteNode()
    let goal: Int
    var remaining: Int {
        didSet {
            updateSprite()
        }
    }

    required init(goal: Int) {
        self.goal = goal
        self.remaining = goal
        super.init()
        self << sprite
        updateSprite()
        size = sprite.size
        keepRotating()
    }

    required convenience init() {
        self.init(goal: 30)
    }

    required init?(coder: NSCoder) {
        self.goal = coder.decodeInt("goal") ?? 30
        self.remaining = coder.decodeInt("remaining") ?? 30
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(goal, key: "goal")
        encoder.encode(remaining, key: "remaining")
    }

    func updateSprite() {
        if remaining <= 0 && scaleToComponent == nil {
            scaleTo(0, duration: 1, removeNode: true)
            fadeTo(0, duration: 0.9)
        }

        sprite.textureId(.Resource(goal: goal, remaining: max(remaining, 0)))
    }

    override func update(dt: CGFloat) {
        if locked {
            decay -= dt
            if decay <= 0 {
                5.times {
                    let node = ShrapnelNode(type: .ColorBox(size: CGSize(10), color: ResourceBlue), size: .Small)
                    node.setupAround(self)
                    world?.addChild(node)
                }
                remaining -= 1
                decay = InitialDecay
            }
        }
    }

    override func disableMovingComponents() {
        super.disableMovingComponents()
        keepRotatingComponent?.enabled = true
    }

}
