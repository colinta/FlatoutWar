//
//  EnemyGiantNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let Health: Float = 40
private let Speed: CGFloat = 15
private let Experience = 10
private let Damage: Float = 50

class EnemyGiantNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(100)
        healthComponent!.startingHealth = Health
        enemyComponent!.experience = Experience
        rammingComponent!.maxSpeed = Speed
        rammingDamage = Damage
    }

    override func generateBigShrapnel(dist dist: CGFloat, angle: CGFloat, spread: CGFloat) {
        guard let world = self.world else { return }

        let position = self.position
        let angle = self.zRotation
        let count = 10
        let dw = self.size.width / CGFloat(count)
        let vx = CGPoint(r: dw, a: angle)
        let vy = CGPoint(r: dw, a: angle + TAU_4)
        count.times { (i: Int) in
            let x: CGPoint = (0.5 + CGFloat(count) / 2 - CGFloat(i)) * vx
            count.times { (j: Int) in
                let y: CGPoint = (0.5 + CGFloat(count) / 2 - CGFloat(j)) * vy

                let node = ShrapnelNode(type: .Enemy(enemyType(), health: 100), size: .Small)
                node.setupAround(self, at: position + x + y)

                let dest = CGPoint(r: rand(min: dist, max: dist * 1.5), a: angle ± rand(spread))
                node.moveToComponent?.target = node.position + dest
                world << node
            }
        }
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
