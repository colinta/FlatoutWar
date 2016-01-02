//
//  EnemyLeaderNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 6

class EnemyLeaderNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(20)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 3
        rammingComponent!.damage = 12
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Leader
    }

}
