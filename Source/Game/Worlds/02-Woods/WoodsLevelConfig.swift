////
///  WoodsLevelConfig.swift
//

typealias TreeInfo = WoodsLevel.TreeInfo

class WoodsLevelConfig: LevelConfig {

    override func availablePowerups() -> [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }
}

class WoodsLevelPart1Config: WoodsLevelConfig {
    override func availableArmyNodes() -> [Node] {
        return [DroneNode(at: CGPoint(r: 80, a: rand(TAU)))]
    }
}

class WoodsLevelPart2Config: WoodsLevelConfig {
    override func availableArmyNodes() -> [Node] {
        let a1: CGFloat = rand(TAU)
        let a2: CGFloat = a1 + TAU_2 ± rand(TAU_12)
        let upgraded = DroneNode(at: CGPoint(r: 80, a: a1))
        upgraded.radarUpgrade = true
        upgraded.bulletUpgrade = true
        upgraded.movementUpgrade = true
        return [
            DroneNode(at: CGPoint(r: 80, a: a2)),
            upgraded
        ]
    }
}
