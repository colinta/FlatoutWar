////
///  BaseLevel5Config.swift
//

class BaseLevel5Config: BaseConfig {
    override var possibleExperience: Int { return 2 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }
}
