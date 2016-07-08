////
///  BaseLevel3Config.swift
//

class BaseLevel3Config: BaseConfig {
    override var possibleExperience: Int { return 155 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel4()
    }

}
