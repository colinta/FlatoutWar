////
///  OceanLevel3Config.swift
//

class OceanLevel3Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel4()
    }

}
