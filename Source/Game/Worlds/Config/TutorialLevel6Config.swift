////
///  TutorialLevel6Config.swift
//

class TutorialLevel6Config: BaseConfig {
    override var canUpgrade: Bool { return false }

    override var possibleExperience: Int { return 180 }
    // override var requiredExperience: Int { return 150 }
    override var expectedResources: Int { return 70 }

    override func nextLevel() -> Level {
        return BaseLevel1()
    }

}
