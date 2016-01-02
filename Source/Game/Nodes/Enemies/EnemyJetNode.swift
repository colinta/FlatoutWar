//
//  EnemyJetNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 1

class EnemyJetNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(8)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 2
        rammingComponent!.maxSpeed = 30
        rammingComponent!.damage = 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Jet
    }

}
