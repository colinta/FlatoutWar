////
///  OceanLevel1Config.swift
//

class OceanLevel1Config: OceanLevelPart1Config {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel2()
    }
}
