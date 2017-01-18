////
///  BaseLevel5.swift
//

class BaseLevel5: BaseLevel {

    override func loadConfig() -> LevelConfig { return BaseLevel5Config() }
    override func goToNextWorld() {
        director?.presentWorld(WorldSelectWorld(beginAt: .Base))
    }

    override func populateLevel() {
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
