////
///  SoldierNode.swift
//

private let StartingHealth: Float = 4
private let Speed: CGFloat = 50

class SoldierNode: Node {
    private var sprite = SKSpriteNode(id: .none)
    var restingPosition: CGPoint?

    func updateTexture() {
        sprite.textureId(.soldier(health: healthComponent?.healthInt ?? 100))
    }

    required init() {
        super.init()

        sprite.z = .below
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
            enemy.healthComponent?.inflict(damage: damage)
            healthComponent.inflict(damage: damage)
        }
        addComponent(rammingComponent)

        let rotateComponent = RotateToComponent()
        rotateComponent.angularAccel = nil
        rotateComponent.maxAngularSpeed = 5
        addComponent(rotateComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func generateKilledExplosion() {
        guard let world = world else { return }

        let explosion = EnemyExplosionNode(at: position)
        world << explosion
    }

}
