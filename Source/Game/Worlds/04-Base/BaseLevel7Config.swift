////
///  BaseLevel7Config.swift
//

class BaseLevel7Config: BaseLevelConfig {
    override var possibleExperience: Int { return 175 }

    override func nextLevel() -> Level {
        return BaseLevel8()
    }
}
