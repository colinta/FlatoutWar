////
///  WoodsLevel1Config.swift
//

class WoodsLevel1Config: WoodsLevelPart1Config {
    override var possibleExperience: Int { return 220 }

    override func nextLevel() -> Level {
        return WoodsLevel2()
    }
}
