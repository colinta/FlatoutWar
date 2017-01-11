////
///  BaseLevelConfig.swift
//

class BaseLevelConfig: LevelConfig {
    override var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var availablePlayers: [Node] {
        return [DroneNode()]
    }
}
