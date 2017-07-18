////
///  WoodsLevel7Config.swift
//

class WoodsLevel7Config: WoodsLevelPart2Config {
    override var possibleExperience: Int { return 175 }

    override func nextLevel() -> Level {
        return WoodsLevel8()
    }
}
