////
///  BaseLevel3Config.swift
//

class BaseLevel3Config: LevelConfig {
    override var possibleExperience: Int { return 155 }

    override func nextLevel() -> Level {
        return BaseLevel4()
    }

}
