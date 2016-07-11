////
///  BaseLevel1Config.swift
//

class BaseLevel1Config: LevelConfig {
    override var possibleExperience: Int { return 225 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel2()
    }

}
