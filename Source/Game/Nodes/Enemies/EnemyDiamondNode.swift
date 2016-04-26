//
//  EnemyDiamondNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/19/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 2

class EnemyDiamondNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 30

    required init() {
        super.init()
        size = CGSize(20, 11.547005383792516)
        healthComponent!.startingHealth = startingHealth
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Diamond
    }

}
