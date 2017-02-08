////
///  BaseLevel7Config.swift
//

class BaseLevel7Config: BaseLevelPart2Config {
    override var possibleExperience: Int { return 2 }

    override func nextLevel() -> Level {
        return BaseLevel8()
    }
}
