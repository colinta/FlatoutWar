////
///  EnemyDozerNode.swift
//

private let startingHealth: Float = 12

class EnemyDozerNode: EnemySoldierNode {
    var minTargetDist: CGFloat = 125

    required init() {
        super.init()
        size = CGSize(width: 5, height: 50)
        shape = .Rect
        rammingDamage = 16
        healthComponent!.startingHealth = startingHealth
        enemyComponent!.blocksNextWave = false
        enemyComponent!.experience = 2
        rammingComponent!.maxSpeed = 20
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func enemyType() -> ImageIdentifier.EnemyType {
        return .Dozer
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
