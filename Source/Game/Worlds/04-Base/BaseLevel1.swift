////
///  BaseLevel1.swift
//

class BaseLevel1: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel1Config() }

    override func populateWorld() {
        super.populateWorld()
        generateEastBase()
    }
}
