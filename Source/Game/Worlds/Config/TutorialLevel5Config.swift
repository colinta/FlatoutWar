////
///  TutorialLevel5Config.swift
//

class TutorialLevel5Config: BaseConfig {
    override var canUpgrade: Bool { return false }

    override var possibleExperience: Int { return 145 }
    // override var requiredExperience: Int { return 120 }
    override var expectedResources: Int { return 60 }

    override func tutorial() -> Tutorial? { return DroneTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel6()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
