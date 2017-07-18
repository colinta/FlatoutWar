////
///  BaseLevel7.swift
//

class BaseLevel7: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel7Config() }

    override func populateWorld() {
        super.populateWorld()
        generateNorthBase()
    }
}
