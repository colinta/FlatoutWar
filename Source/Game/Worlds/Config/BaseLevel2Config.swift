////
///  BaseLevel2Config.swift
//

class BaseLevel2Config: BaseLevelPart1Config {
    override var possibleExperience: Int { return 230 }

    override func nextLevel() -> Level {
        return BaseLevel3()
    }

}
