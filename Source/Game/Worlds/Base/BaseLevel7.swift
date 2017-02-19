////
///  BaseLevel7.swift
//

class BaseLevel7: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel7Config() }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
