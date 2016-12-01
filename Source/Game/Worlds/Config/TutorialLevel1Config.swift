////
///  TutorialLevel1Config.swift
//

class TutorialLevel1Config: TutorialConfig {
    override var canPowerup: Bool { return false }
    override var trackResources: Bool { return false }
    override var availableTurrets: [Turret] { return [] }

    override var possibleExperience: Int { return 100 }
    // override var requiredExperience: Int { return 90 }

    override func tutorial() -> Tutorial? { return AutoFireTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel2()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
