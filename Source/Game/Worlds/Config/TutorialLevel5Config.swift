////
///  TutorialLevel5Config.swift
//

class TutorialLevel5Config: TutorialConfig {
    override var activatedPowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var possibleExperience: Int { return 145 }

    override func tutorial() -> Tutorial? { return DroneTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel6()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
