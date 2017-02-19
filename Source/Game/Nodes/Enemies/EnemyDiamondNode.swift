////
///  EnemyDiamondNode.swift
//

private let StartingHealth: Float = 2

class EnemyDiamondNode: EnemySoldierNode {
    static let DefaultJetSpeed: CGFloat = 30

    required init() {
        super.init()
        size = CGSize(20, 11.547005383792516)
        healthComponent!.startingHealth = StartingHealth
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Diamond
    }

}
