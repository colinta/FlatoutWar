////
///  OceanLevel5Config.swift
//

class OceanLevel5Config: OceanLevelPart2Config {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel6()
    }
}
