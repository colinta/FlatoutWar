////
///  BaseLevel2.swift
//

class BaseLevel2: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel2Config() }

    override func populateWorld() {
        super.populateWorld()
        generateEastBase()
    }
}
