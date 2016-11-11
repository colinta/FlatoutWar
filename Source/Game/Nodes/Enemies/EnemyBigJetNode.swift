////
///  EnemyBigJetNode.swift
//

private let StartingHealth: Float = 5
private let Experience: Int = 5

class EnemyBigJetNode: EnemyJetNode {

    required init() {
        super.init()
        size = CGSize(16)
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
        rammingDamage = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .BigJet
    }

}
