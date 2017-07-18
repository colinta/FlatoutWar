////
///  EnemySlowSoldierNode.swift
//

private let StartingHealth: Float = 4
private let Speed: CGFloat = 15
private let Damage: Float = 6
private let Experience = 1

class EnemySlowSoldierNode: EnemySoldierNode {

    required init() {
        super.init()
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
        rammingDamage = Damage
        rammingComponent!.maxSpeed = Speed
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .slowSoldier
    }

}
