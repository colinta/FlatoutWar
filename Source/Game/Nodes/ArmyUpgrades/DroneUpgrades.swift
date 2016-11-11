////
///  DroneUpgrades.swift
//

extension DroneNode: UpgradeableNodes {

    func availableUpgrades(world upgradeWorld: World) -> [(Button, String)] {
        var upgrades: [(Button, String)] = []
        do {
            let button = Button()
            button.enabled = !speedUpgrade.boolValue
            button.style = .Circle

            let art = SKSpriteNode(id: .Drone(
                speedUpgrade: .True,
                radarUpgrade: radarUpgrade,
                bulletUpgrade: bulletUpgrade,
                health: 100)
            )
            button << art

            upgrades << (button, "SPEED")
        }

        do {
            let button = Button()
            button.enabled = !bulletUpgrade.boolValue
            button.style = .Circle

            let art = SKSpriteNode(id: .Drone(
                speedUpgrade: speedUpgrade,
                radarUpgrade: radarUpgrade,
                bulletUpgrade: .True,
                health: 100)
            )
            button << art

            upgrades << (button, "BULLET")
        }

        do {
            let button = Button()
            button.enabled = !radarUpgrade.boolValue
            button.style = .Circle

            let art = SKSpriteNode(id: .Drone(
                speedUpgrade: speedUpgrade,
                radarUpgrade: .True,
                bulletUpgrade: bulletUpgrade,
                health: 100)
            )
            button << art

            let halo = SKSpriteNode(id: .DroneRadarUpgrade)
            button << halo

            upgrades << (button, "RADAR")
        }

        return upgrades
    }
}
