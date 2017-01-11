////
///  BaseLevel1Config.swift
//

class BaseLevel1Config: BaseLevelConfig {
    override var possibleExperience: Int { return 220 }

    override func nextLevel() -> Level {
        return BaseLevel2()
    }
}
