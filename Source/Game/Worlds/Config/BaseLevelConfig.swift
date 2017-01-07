////
///  BaseLevelConfig.swift
//

class BaseLevelConfig: LevelConfig {
    override var availablePlayers: [Node] {
        return [DroneNode()]
    }
}
