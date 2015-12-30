//
//  SoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class SoldierNode: Node {

    required init() {
        super.init()
        size = CGSize(r: 5)

        onDeath {
            if let world = self.world {
                let explosion = Node(at: self.position)
                world << explosion
            }
        }

        let enemyComponent = EnemyComponent()
        enemyComponent.experience = 1
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.healthComponent?.health -= damage
                self.generateShrapnel(damage)
            }
        }
        addComponent(enemyComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func populate() {
        self << SKSpriteNode(id: .Enemy(type: .Soldier))
    }

    func generateShrapnel(damage: Float) {
        Int(damage * 10).times {
            let node = EnemyShrapnelNode(type: .Soldier)
            node.position = self.position
            let rotate = KeepRotatingComponent()
            rotate.rate = rand(min: 1, max: 2)
            node.addComponent(rotate)

            let duration = CGFloat(0.5)

            let move = MoveToComponent()
            let dest = CGPoint(r: rand(min: 15, max: 30), a: rand(TAU))
            move.target = self.position + dest
            move.duration = duration
            node.addComponent(move)

            let fade = FadeToComponent()
            fade.target = 0
            fade.duration = duration
            fade.removeOnFaded()
            node.addComponent(fade)

            self.world! << node
        }
    }

}
