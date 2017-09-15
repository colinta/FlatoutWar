////
///  OceanLevel5Config.swift
//

class OceanLevel5Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel6()
    }
}
