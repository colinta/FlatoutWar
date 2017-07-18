////
///  EnemyScoutNode.swift
//

private let StartingHealth: Float = 1
private let Damage: Float = 2
private let Experience = 1

class EnemyScoutNode: EnemySoldierNode {

    required init() {
        super.init()
        size = CGSize(8)
        rammingDamage = Damage
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.experience = Experience
        rammingComponent!.maxSpeed = 35
        rotateToComponent!.angularAccel = 5
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .scout
    }

}
