////
///  BaseLevel6.swift
//

class BaseLevel6: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel6Config() }

    override func populateWorld() {
        super.populateWorld()
        generateWestBase()
    }
}
