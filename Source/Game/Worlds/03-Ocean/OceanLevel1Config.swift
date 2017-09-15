////
///  OceanLevel1Config.swift
//

class OceanLevel1Config: OceanLevelConfig {
    override var possibleExperience: Int { return 999 }

    override func availablePowerups() -> [Powerup] { return [
        MinesPowerup(count: 2),
        SoldiersPowerup(count: 1),
        NetPowerup(count: 1),
    ] }

    override func availableArmyNodes() -> [Node] {
        let nodes = super.availableArmyNodes()
        let dy: CGFloat = 40
        let septentrions: [Node] = [
            ShotgunNode(at: CGPoint(y: dy)),
            ShotgunNode(at: CGPoint(y: 0)),
            ShotgunNode(at: CGPoint(y: -dy)),
        ]
        return nodes + septentrions
    }

    override func nextLevel() -> Level {
        return OceanLevel2()
    }
}
