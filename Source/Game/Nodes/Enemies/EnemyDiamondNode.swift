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

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Diamond
    }

}
