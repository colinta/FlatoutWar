//
//  GrenadePowerupNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class GrenadePowerupNode: Node {

    required init() {
        super.init()

        let sprite = SKSpriteNode(id: .Powerup(type: .Grenade))
        self << sprite
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
