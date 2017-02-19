////
///  WoodsLevel6Config.swift
//

class WoodsLevel6Config: WoodsLevelPart2Config {
    override var possibleExperience: Int { return 2 }

    override func nextLevel() -> Level {
        return WoodsLevel7()
    }
}
