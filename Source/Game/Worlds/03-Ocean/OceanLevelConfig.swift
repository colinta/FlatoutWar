////
///  OceanLevelConfig.swift
//

class OceanLevelConfig: LevelConfig {
    override func availablePowerups() -> [Powerup] {
        fatalError("\(self) should implement availablePowerups()")
    }

    override func availableArmyNodes() -> [Node] {
        let a1: CGFloat = TAU_4 ± rand(TAU_12)
        let a2: CGFloat = -TAU_4 ± rand(TAU_12)
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
