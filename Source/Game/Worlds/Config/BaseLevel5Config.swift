////
///  BaseLevel5Config.swift
//

class BaseLevel5Config: BaseLevelPart2Config {
    override var possibleExperience: Int { return 2 }

    override func nextLevel() -> Level {
        return BaseLevel6()
    }
}
