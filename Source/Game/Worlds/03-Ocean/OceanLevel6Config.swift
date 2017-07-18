////
///  OceanLevel6Config.swift
//

class OceanLevel6Config: OceanLevelPart2Config {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel7()
    }
}
