////
///  TutorialLevel3Config.swift
//

class TutorialLevel3Config: TutorialConfig {
    override func availablePowerups() -> [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 125 }

    override func tutorial() -> Tutorial? { return PowerupTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel4()
    }
}
