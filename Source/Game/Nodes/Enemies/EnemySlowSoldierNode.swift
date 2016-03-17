//
//  EnemySlowSoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 4

class EnemySlowSoldierNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(8)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 2
        rammingDamage = 4
        rammingComponent!.maxSpeed = 15
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .SlowSoldier
    }

}
