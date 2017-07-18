////
///  BaseLevel5.swift
//

class BaseLevel5: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel5Config() }

    override func populateWorld() {
        super.populateWorld()
        generateWestBase()
    }
}
