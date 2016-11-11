////
///  EnemyJetNode.swift
//

private let Health: Float = 1
private let Experience = 1

class EnemyJetNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 40

    required init() {
        super.init()
        size = CGSize(8)
        rammingDamage = 2

        playerTargetingComponent!.onTargetAcquired { target in
            if let target = target {
                self.rotateTowards(target)
            }
        }

        let flyingComponent = FlyingComponent()
        flyingComponent.intersectionNode = rammingComponent!.intersectionNode
        flyingComponent.bindTo(targetingComponent: playerTargetingComponent!)
        flyingComponent.maxSpeed = EnemyJetNode.DefaultJetSpeed
        flyingComponent.maxTurningSpeed = EnemyJetNode.DefaultJetSpeed
        flyingComponent.onRammed(self.onRammed)
        rammingComponent!.removeFromNode()
        addComponent(flyingComponent)

        healthComponent!.startingHealth = Health
        enemyComponent!.experience = Experience
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Jet
    }

}
