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

class ResourceNode: Node {
    var locked = false
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
        sprite.textureId(.Resource(goal: goal, remaining: remaining))
    }

    override func disableMovingComponents() {
        super.disableMovingComponents()
        keepRotatingComponent?.enabled = true
    }

}
