//
//  EnemyGiantNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 40

class EnemyGiantNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(100)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 15
        rammingComponent!.maxSpeed = 15
        rammingDamage = 50
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
