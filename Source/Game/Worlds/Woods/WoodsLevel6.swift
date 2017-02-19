////
///  WoodsLevel6.swift
//

class WoodsLevel6: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel6Config() }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
