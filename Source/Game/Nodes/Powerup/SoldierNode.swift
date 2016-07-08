////
///  SoldierNode.swift
//

private let StartingHealth: Float = 4
private let Speed: CGFloat = 50

class SoldierNode: Node {
    var sprite = SKSpriteNode(id: .None)
    var restingPosition: CGPoint?

    required init() {
        super.init()

        sprite.z = .Below
        self << sprite

        let healthComponent = HealthComponent(health: StartingHealth)
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
        targetingComponent.onTargetAcquired { target in
            self.moveToComponent?.removeFromNode()
            if target == nil {
                self.rammingComponent?.tempTarget = self.restingPosition
            }
            else {
                self.rammingComponent?.tempTarget = nil
            }
        }
        addComponent(targetingComponent)

        let rammingComponent = EnemyRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.maxSpeed = Speed
        rammingComponent.maxTurningSpeed = Speed
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
