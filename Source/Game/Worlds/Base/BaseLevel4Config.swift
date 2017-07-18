////
///  BaseLevel4Config.swift
//

class BaseLevel4Config: BaseLevelConfig {
    override var possibleExperience: Int { return 150 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }

}
