////
///  BaseLevel8.swift
//

class BaseLevel8: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel8Config() }

    override func populateWorld() {
        super.populateWorld()
        generateNorthBase()
    }
}
