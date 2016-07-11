////
///  TutorialLevel4Config.swift
//

class TutorialLevel4Config: TutorialConfig {
    override var canUpgrade: Bool { return false }
    override var activatedPowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 130 }
    // override var requiredExperience: Int { return 115 }
    override var expectedResources: Int { return 30 }

    override func tutorial() -> Tutorial? { return RapidFireTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel5()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
