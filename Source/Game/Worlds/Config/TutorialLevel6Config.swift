////
///  TutorialLevel6Config.swift
//

class TutorialLevel6Config: TutorialConfig {
    override var canUpgrade: Bool { return false }
    override var activatedPowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 180 }
    // override var requiredExperience: Int { return 150 }
    override var expectedResources: Int { return 70 }

    override func nextLevel() -> Level {
        return BaseLevel1()
    }

}
