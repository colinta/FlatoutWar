////
///  DroneUpgrades.swift
//


extension DroneNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "DODEC DRONE"
    }

    func applyUpgrade(type: UpgradeType) {
        switch type {
        case .RadarUpgrade:
            radarUpgrade = true
        case .BulletUpgrade:
            bulletUpgrade = true
        case .SpeedUpgrade:
            speedUpgrade = true
        default:
            return
        }
    }

    func availableUpgrades(world upgradeWorld: World) -> [(ArmyUpgradeButton, UpgradeInfo)] {
        var upgrades: [(ArmyUpgradeButton, UpgradeInfo)] = []

        var rate: CGFloat = 2
        if radarUpgrade.boolValue { rate -= 0.3 }
        if speedUpgrade.boolValue { rate -= 0.3 }
        if bulletUpgrade.boolValue { rate -= 0.3 }

        do {
            let info = UpgradeInfo(
                title: "SPEED",
                upgradeType: .SpeedUpgrade,
                description: ["INCREASED SPEED", "FASTER FIRING"],
                cost: Currency(experience: 400, resources: 100),
                rate: rate
            )

            let node = DroneNode()
            node.scale1.removeFromParent()
            node.scale2.removeFromParent()
            node.phaseComponent?.enabled = false
            node.speedUpgrade = .True
            node.radarUpgrade = radarUpgrade
            node.bulletUpgrade = bulletUpgrade

            let button = ArmyUpgradeButton(node: node, info: info)
            button.upgradeEnabled = !speedUpgrade.boolValue

            upgrades << (button, info)
        }

        do {
            let info = UpgradeInfo(
                title: "BULLET",
                upgradeType: .BulletUpgrade,
                description: ["INCREASED DAMAGE", "FASTER BULLET SPEED"],
                cost: Currency(experience: 350, resources: 100),
                rate: rate
            )

            let node = DroneNode()
            node.scale1.removeFromParent()
            node.scale2.removeFromParent()
            node.phaseComponent?.enabled = false
            node.speedUpgrade = speedUpgrade
            node.radarUpgrade = radarUpgrade
            node.bulletUpgrade = .True

            let button = ArmyUpgradeButton(node: node, info: info)
            button.upgradeEnabled = !bulletUpgrade.boolValue

            upgrades << (button, info)
        }

        do {
            let info = UpgradeInfo(
                title: "RADAR",
                upgradeType: .RadarUpgrade,
                description: ["LARGER RADAR", "PREEMPTIVE TARGETING"],
                cost: Currency(experience: 1000, resources: 100),
                rate: rate
            )

            let node = DroneNode()
            node.scale1.removeFromParent()
            node.scale2.removeFromParent()
            node.phaseComponent?.enabled = false
            node.speedUpgrade = speedUpgrade
            node.radarUpgrade = .True
            node.bulletUpgrade = bulletUpgrade

            let button = ArmyUpgradeButton(node: node, info: info)
            button.upgradeEnabled = !radarUpgrade.boolValue

            upgrades << (button, info)
        }

        return upgrades
    }
}

extension HasUpgrade {

    var droneRadarRadius: CGFloat {
        switch self {
        case .False: return 75
        case .True: return 100
        }
    }

    var droneCooldown: CGFloat {
        switch self {
        case .False: return 0.4
        case .True: return 0.3
        }
    }

    var droneBulletSpeed: CGFloat {
        switch self {
        case .False: return 125
        case .True: return 135
        }
    }

    var droneBulletDamage: Float {
        switch self {
        case .False: return 1
        case .True: return 1.5
        }
    }

    var droneMovementSpeed: CGFloat {
        switch self {
        case .False: return 40
        case .True: return 60
        }
    }

}
