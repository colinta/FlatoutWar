////
///  EnemyFastSoldierNode.swift
//

private let StartingHealth: Float = 2
private let Speed: CGFloat = 35
private let Damage: Float = 6
private let Experience = 1

class EnemyFastSoldierNode: EnemySoldierNode {

    required init() {
        super.init()
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
        rammingDamage = Damage
        rammingComponent!.maxSpeed = Speed
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .FastSoldier
    }

}
