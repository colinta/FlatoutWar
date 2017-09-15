////
///  TutorialLevel7Config.swift
//

class TutorialLevel7Config: TutorialConfig {
    override func availablePowerups() -> [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 145 }

    override func tutorial() -> Tutorial? { return DroneTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel8()
    }

}
