////
///  TutorialLevel4Config.swift
//

class TutorialLevel4Config: TutorialConfig {
    override var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 0 }

    override func nextLevel() -> Level {
        return TutorialLevel5()
    }
}
