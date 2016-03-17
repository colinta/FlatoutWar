//
//  SoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 2

class SoldierNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 25
    var sprite = SKSpriteNode(id: .None)

    required init() {
        super.init()
        size = CGSize(10)

        sprite.zPosition = Z.Below.rawValue
        self << sprite

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { _ in
            self.updateTexture()
        }
        healthComponent.onKilled {
            self.generateKilledExplosion()
            self.removeFromParent()
        }
        addComponent(healthComponent)
        updateTexture()

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.radius = 100
        addComponent(targetingComponent)

        let rammingComponent = EnemyRammingComponent()
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.intersectionNode = sprite
        rammingComponent.maxSpeed = SoldierNode.DefaultSoldierSpeed
        rammingComponent.onRammed {
            self.removeFromParent()
        }
        rammingComponent.damage = 5
        addComponent(rammingComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func updateTexture() {
        sprite.textureId(.Soldier(health: healthComponent?.healthInt ?? 100))
    }

    func generateKilledExplosion() {
        if let world = self.world {
            let explosion = EnemyExplosionNode(at: self.position)
            world << explosion
        }
    }

}
