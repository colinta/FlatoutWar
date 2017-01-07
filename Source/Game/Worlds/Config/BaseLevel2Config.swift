////
///  BaseLevel2Config.swift
//

class BaseLevel2Config: LevelConfig {
    override var possibleExperience: Int { return 150 }

    override func nextLevel() -> Level {
        return BaseLevel3()
    }

}
