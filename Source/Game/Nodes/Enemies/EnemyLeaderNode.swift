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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Leader
    }

}
