////
///  EnemyDozerNode.swift
//

private let StartingHealth: Float = 12
private let Damage: Float = 16
private let Experience = 2

class EnemyDozerNode: EnemySoldierNode {
    var minTargetDist: CGFloat = 125

    required init() {
        super.init()
        name = "dozer"
        size = CGSize(width: 5, height: 50)
        shape = .rect
        rammingDamage = Damage
        healthComponent!.startingHealth = StartingHealth
        enemyComponent!.blocksNextWave = false
        enemyComponent!.experience = Experience
        rammingComponent!.maxSpeed = 20
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .dozer
    }

    override func update(_ dt: CGFloat) {
        super.update(dt)
        if
            let rammingComponent = rammingComponent,
            let target = rammingComponent.currentTarget,
            distanceTo(target, within: minTargetDist)
        {
            rammingComponent.removeFromNode()
        }
    }

}
