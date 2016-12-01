////
///  TutorialLevel3Config.swift
//

class TutorialLevel3Config: TutorialConfig {
    override var availableTurrets: [Turret] { return [] }
    override var activatedPowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 125 }
    // override var requiredExperience: Int { return 100 }
    override var expectedResources: Int { return 20 }

    override func tutorial() -> Tutorial? { return PowerupTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel4()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
