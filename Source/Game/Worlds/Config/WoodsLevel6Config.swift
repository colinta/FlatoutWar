////
///  WoodsLevel6Config.swift
//

class WoodsLevel6Config: WoodsLevelPart2Config {
    override var possibleExperience: Int { return 152 }

    override func nextLevel() -> Level {
        return WoodsLevel7()
    }
}
