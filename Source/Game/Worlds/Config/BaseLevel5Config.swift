////
///  BaseLevel5Config.swift
//

class BaseLevel5Config: LevelConfig {
    override var possibleExperience: Int { return 2 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }
}
