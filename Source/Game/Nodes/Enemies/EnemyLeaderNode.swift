////
///  EnemyLeaderNode.swift
//

private let startingHealth: Float = 6

class EnemyLeaderNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(20)
        rammingDamage = 12
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 3
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Leader
    }

}
