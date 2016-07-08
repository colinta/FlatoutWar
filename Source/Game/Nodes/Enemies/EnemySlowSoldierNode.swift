////
///  EnemySlowSoldierNode.swift
//

private let StartingHealth: Float = 4
private let Speed: CGFloat = 15
private let Damage: Float = 6

class EnemySlowSoldierNode: EnemySoldierNode {

    required init() {
        super.init()
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = 1
        rammingDamage = Damage
        rammingComponent!.maxSpeed = Speed
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .SlowSoldier
    }

}
