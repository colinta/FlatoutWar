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
                (BomberPowerup(count: 0), nil),
                (CoffeePowerup(count: 0), nil),
                (HourglassPowerup(count: 0), nil),
                (NetPowerup(count: 0), nil),
                (PulsePowerup(count: 0), nil),
                (ShieldPowerup(count: 0), nil),
                (SoldiersPowerup(count: 0), nil),
            ]
        }
        set {}
    }
}
