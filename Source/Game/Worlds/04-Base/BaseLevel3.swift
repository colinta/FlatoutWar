////
///  BaseLevel3.swift
//

class BaseLevel3: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel3Config() }

    override func populateWorld() {
        super.populateWorld()
        generateSouthBase()
    }
}
