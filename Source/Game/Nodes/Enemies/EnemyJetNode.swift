////
///  EnemyJetNode.swift
//

private let StartingHealth: Float = 1
private let Experience = 1
private let Damage: Float = 2

class EnemyJetNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 40

    required init() {
        super.init()
        size = CGSize(8)
        rammingDamage = Damage

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

        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Jet
    }

}
