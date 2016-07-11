////
///  TutorialLevel2Config.swift
//

class TutorialLevel2Config: TutorialConfig {
    override var canUpgrade: Bool { return false }
    override var canPowerup: Bool { return false }
    override var availableTurrets: [Turret] { return [] }
    override var activatedPowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 110 }
    // override var requiredExperience: Int { return 100 }
    override var expectedResources: Int { return 60 }

    override func tutorial() -> Tutorial? { return ResourceTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel3()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
