////
///  WoodsLevel5Config.swift
//

class WoodsLevel5Config: WoodsLevelPart2Config {
    override var possibleExperience: Int { return 145 }

    override func nextLevel() -> Level {
        return WoodsLevel6()
    }
}
