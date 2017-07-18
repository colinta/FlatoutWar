////
///  OceanLevel7Config.swift
//

class OceanLevel7Config: OceanLevelPart2Config {
    override var possibleExperience: Int { return 999 }

    override func nextLevel() -> Level {
        return OceanLevel8()
    }
}
