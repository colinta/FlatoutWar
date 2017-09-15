////
///  OceanLevel4Config.swift
//

class OceanLevel4Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel5()
    }

}
