////
///  WoodsLevel4Config.swift
//

class WoodsLevel4Config: WoodsLevelPart2Config {
    override var possibleExperience: Int { return 150 }

    override func nextLevel() -> Level {
        return WoodsLevel5()
    }

}
