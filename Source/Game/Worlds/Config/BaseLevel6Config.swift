////
///  BaseLevel6Config.swift
//

class BaseLevel6Config: BaseLevelPart2Config {
    override var possibleExperience: Int { return 2 }

    override func nextLevel() -> Level {
        return BaseLevel7()
    }
}
