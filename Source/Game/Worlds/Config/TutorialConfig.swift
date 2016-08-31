////
///  TutorialConfig.swift
//

class TutorialConfig: LevelConfig {
    override var storedPowerups: [(powerup: Powerup, order: Int?)] {
        get {
            return [
                (GrenadePowerup(count: 2), 0),
                (LaserPowerup(count: 1), 1),
                (MinesPowerup(count: 1), 2),
            ]
        }
        set {}
    }
}
