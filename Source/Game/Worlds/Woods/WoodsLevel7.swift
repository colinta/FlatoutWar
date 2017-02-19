////
///  WoodsLevel7.swift
//

class WoodsLevel7: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel7Config() }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
