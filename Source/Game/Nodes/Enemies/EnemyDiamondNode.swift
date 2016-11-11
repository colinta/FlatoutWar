////
///  EnemyDiamondNode.swift
//

private let startingHealth: Float = 2

class EnemyDiamondNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 30

    required init() {
        super.init()
        size = CGSize(20, 11.547005383792516)
        healthComponent!.startingHealth = startingHealth
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Diamond
    }

}
