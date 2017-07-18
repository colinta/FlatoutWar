////
///  BaseLevel6Config.swift
//

class BaseLevel6Config: BaseLevelConfig {
    override var possibleExperience: Int { return 152 }

    override func nextLevel() -> Level {
        return BaseLevel7()
    }
}
