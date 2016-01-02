//
//  EnemyGiantNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 25

class EnemyGiantNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(r: 50)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 15
        rammingComponent!.maxSpeed = 15
        rammingComponent!.damage = 50
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .GiantSoldier
    }

}
