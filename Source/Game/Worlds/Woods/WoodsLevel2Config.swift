////
///  WoodsLevel2Config.swift
//

class WoodsLevel2Config: WoodsLevelPart1Config {
    override var possibleExperience: Int { return 230 }

    override func nextLevel() -> Level {
        return WoodsLevel3()
    }

}
