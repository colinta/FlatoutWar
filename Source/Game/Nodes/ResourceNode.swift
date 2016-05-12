//
//  ResourceNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/12/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ResourceNode: Node {
    let sprite = SKSpriteNode()
    let amount: Int
    var remaining: Int {
        didSet {
            updateSprite()
        }
    }

    required init(amount: Int) {
        self.amount = amount
        self.remaining = amount
        super.init()
        self << sprite
        updateSprite()
        size = CGSize(20)
    }

    required convenience init() {
        self.init(amount: 30)
    }

    required init?(coder: NSCoder) {
        self.amount = coder.decodeInt("amount") ?? 30
        self.remaining = coder.decodeInt("remaining") ?? 30
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(amount, key: "amount")
        encoder.encode(remaining, key: "remaining")
    }

    func updateSprite() {
        sprite.textureId(.Resource(amount: amount, remaining: remaining))
    }

}
