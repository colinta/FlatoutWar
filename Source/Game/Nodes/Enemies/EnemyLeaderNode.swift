////
///  EnemyLeaderNode.swift
//

private let StartingHealth: Float = 6
private let Damage: Float = 12
private let Experience = 3

class EnemyLeaderNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(20)
        rammingDamage = Damage
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Leader
    }

}
