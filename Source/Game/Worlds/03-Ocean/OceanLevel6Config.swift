////
///  OceanLevel6Config.swift
//

class OceanLevel6Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel7()
    }
}
