////
///  EnemyBigJetNode.swift
//

private let startingHealth: Float = 5

class EnemyBigJetNode: EnemyJetNode {

    required init() {
        super.init()
        size = CGSize(16)
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 10
        rammingDamage = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .BigJet
    }

}
