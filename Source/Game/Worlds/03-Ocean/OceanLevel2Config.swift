////
///  OceanLevel2Config.swift
//

class OceanLevel2Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel3()
    }

}
