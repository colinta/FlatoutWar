//
//  EnemyScoutNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 1

class EnemyScoutNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(8)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 1
        rammingComponent!.damage = 2
        rammingComponent!.maxSpeed = 35
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Scout
    }

}
