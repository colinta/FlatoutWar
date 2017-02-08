////
///  BaseLevel4Config.swift
//

class BaseLevel4Config: BaseLevelPart2Config {
    override var possibleExperience: Int { return 124 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }

}
