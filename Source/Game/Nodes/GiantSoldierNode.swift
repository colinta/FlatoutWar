//
//  GiantSoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 20

class GiantSoldierNode: SoldierNode {

    required init() {
        super.init()
        size = CGSize(r: 50)
        healthComponent!.startingHealth = startingHealth
        rammingComponent!.maxSpeed = 15
        enemyComponent!.experience = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func texture() -> SKTexture {
        return SKTexture.id(.Enemy(type: .GiantSoldier))
    }

}
