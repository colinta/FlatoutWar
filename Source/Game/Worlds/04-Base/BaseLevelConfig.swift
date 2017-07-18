////
///  BaseLevelConfig.swift
//

class BaseLevelConfig: LevelConfig {
    override var availableArmyNodes: [Node] {
        return [DroneNode(at: CGPoint(r: 80, a: rand(TAU)))]
    }

    override var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }
}
