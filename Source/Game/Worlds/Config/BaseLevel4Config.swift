////
///  BaseLevel4Config.swift
//

class BaseLevel4Config: BaseConfig {
    override var possibleExperience: Int { return 1000 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }

}
