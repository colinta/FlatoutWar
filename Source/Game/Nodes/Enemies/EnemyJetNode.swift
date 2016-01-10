//
//  EnemyJetNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 1

class EnemyJetNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 40

    required init() {
        super.init()
        size = CGSize(8)

        rammingComponent!.removeFromNode()
        enemyComponent!.onTargetAcquired { target in
            if let target = target {
                self.rotateTowards(target)
            }
        }

        let flyingComponent = FlyingComponent()
        flyingComponent.intersectionNode = sprite
        flyingComponent.bindTo(enemyComponent: enemyComponent!)
        flyingComponent.maxSpeed = EnemyJetNode.DefaultJetSpeed
        flyingComponent.maxTurningSpeed = EnemyJetNode.DefaultJetSpeed
        flyingComponent.onRammed {
            self.generateExplosion()
            self.removeFromParent()
        }
        flyingComponent.damage = startingHealth * 2
        addComponent(flyingComponent)

        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 1
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
