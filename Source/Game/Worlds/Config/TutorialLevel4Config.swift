////
///  TutorialLevel4Config.swift
//

class TutorialLevel4Config: BaseConfig {
    override var canUpgrade: Bool { return false }

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
