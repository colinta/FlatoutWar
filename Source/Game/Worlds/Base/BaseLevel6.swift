////
///  BaseLevel6.swift
//

class BaseLevel6: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel6Config() }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
