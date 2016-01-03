//
//  EnemyDozerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 8

class EnemyDozerNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(width: 5, height: 50)
        shape = .Rect
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 3
        rammingComponent!.maxSpeed = 20
        rammingComponent!.damage = 16
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Dozer
    }

}
