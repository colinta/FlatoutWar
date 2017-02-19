////
///  EnemyBigJetNode.swift
//

private let StartingHealth: Float = 5
private let Damage: Float = 10
private let Experience = 5

class EnemyBigJetNode: EnemyJetNode {

    required init() {
        super.init()
        size = CGSize(16)
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
        rammingDamage = Damage
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .BigJet
    }

}
