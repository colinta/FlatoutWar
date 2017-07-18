////
///  WoodsLevel3Config.swift
//

class WoodsLevel3Config: WoodsLevelPart1Config {
    override var possibleExperience: Int { return 155 }

    override func nextLevel() -> Level {
        return WoodsLevel4()
    }

}
