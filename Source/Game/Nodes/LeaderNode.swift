//
//  LeaderNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 6

class LeaderNode: SoldierNode {

    required init() {
        super.init()
        size = CGSize(r: 10)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func texture() -> SKTexture {
        return SKTexture.id(.Enemy(type: .Leader))
    }

}
