////
///  BaseLevel4.swift
//

class BaseLevel4: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel4Config() }

    override func populateWorld() {
        super.populateWorld()
        generateSouthBase()
    }
}
