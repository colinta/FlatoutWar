////
///  BaseLevel3Config.swift
//

class BaseLevel3Config: BaseLevelConfig {
    override var possibleExperience: Int { return 155 }

    override func nextLevel() -> Level {
        return BaseLevel4()
    }

}
