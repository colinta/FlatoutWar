////
///  BaseLevel2Config.swift
//

class BaseLevel2Config: BaseConfig {
    override var possibleExperience: Int { return 150 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel3()
    }

}
