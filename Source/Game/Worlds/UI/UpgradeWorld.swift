////
///  UpgradeWorld.swift
//

class UpgradeWorld: World {
    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: BaseConfig { return nextWorld.config }

    override func populateWorld() {
        super.populateWorld()
        // fadeTo(1, start: 0, duration: 0.5)
        self.director?.presentWorld(self.nextWorld)
    }

}
