//
//  SoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 4

class SoldierNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 50
    var sprite = SKSpriteNode(id: .None)

    required init() {
        super.init()

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
        size = sprite.size

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.radius = 200
        targetingComponent.onTargetAcquired { _ in
            self.moveToComponent?.removeFromNode()
        }
        addComponent(targetingComponent)

        let rammingComponent = EnemyRammingComponent()
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.intersectionNode = sprite
        rammingComponent.maxSpeed = SoldierNode.DefaultSoldierSpeed
        rammingComponent.maxTurningSpeed = SoldierNode.DefaultSoldierSpeed
        rammingComponent.onRammed { enemy in
            let damage = min(enemy.healthComponent?.health ?? 0, healthComponent.health)
            enemy.healthComponent?.inflict(damage)
            healthComponent.inflict(damage)
        }
        addComponent(rammingComponent)

        let rotateComponent = RotateToComponent()
        rotateComponent.angularAccel = nil
        rotateComponent.maxAngularSpeed = 5
        addComponent(rotateComponent)
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
