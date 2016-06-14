//
//  EnemyGiantNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 20

class EnemyGiantNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(100)
        healthComponent!.startingHealth = startingHealth
        healthComponent!.onKilled {
            guard let world = self.world else { return }

            let position = self.position
            let angle = self.zRotation
            let dw = self.size.width / 10
            let vx = CGPoint(r: dw, a: angle)
            let vy = CGPoint(r: dw, a: angle + TAU_4)
            10.times { (i: Int) in
                let x: CGPoint = (0.5 + CGFloat(5 - i)) * vx
                10.times { (j: Int) in
                    let y: CGPoint = (0.5 + CGFloat(5 - j)) * vy

                    let soldier = EnemySoldierNode()
                    soldier.zRotation = angle
                    soldier.position = position + x + y
                    world << soldier
                }
            }
        }
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
