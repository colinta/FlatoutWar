////
///  EnemyDozerNode.swift
//

private let startingHealth: Float = 8

class EnemyDozerNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(width: 5, height: 50)
        shape = .Rect
        rammingDamage = 16
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.experience = 2
        rammingComponent!.maxSpeed = 20
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Dozer
    }

}
