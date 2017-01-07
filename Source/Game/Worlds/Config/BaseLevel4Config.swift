////
///  BaseLevel4Config.swift
//

class BaseLevel4Config: LevelConfig {
    override var possibleExperience: Int { return 1000 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }

}
