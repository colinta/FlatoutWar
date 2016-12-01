////
///  BasePlayerUpgrades.swift
//

extension BasePlayerNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "ICOSAGON"
    }

    func applyUpgrade(type: UpgradeType) {
        switch type {
        case .RadarUpgrade:
            radarUpgrade = true
        case .BulletUpgrade:
            bulletUpgrade = true
        case .RotateUpgrade:
            rotateUpgrade = true
        default:
            return
        }
    }

    func availableUpgrades(world upgradeWorld: World) -> [(ArmyUpgradeButton, UpgradeInfo)] {
        var upgrades: [(ArmyUpgradeButton, UpgradeInfo)] = []

        var rate: CGFloat = 2.5
        if radarUpgrade.boolValue { rate -= 0.1 }
        if rotateUpgrade.boolValue { rate -= 0.3 }
        if bulletUpgrade.boolValue { rate -= 0.3 }

        do {
            let info = UpgradeInfo(
                title: "SPEED",
                upgradeType: .RotateUpgrade,
                description: ["INCREASED SPEED", "FASTER FIRING"],
                cost: Currency(experience: 450, resources: 150),
                rate: rate
            )

            let node = BasePlayerNode()
            node.radarNode.removeFromParent()
            node.rotateUpgrade = .True
            node.radarUpgrade = radarUpgrade
            node.bulletUpgrade = bulletUpgrade

            let button = ArmyUpgradeButton(node: node, info: info)
            button.upgradeEnabled = !rotateUpgrade.boolValue

            upgrades << (button, info)
        }

        do {
            let info = UpgradeInfo(
                title: "BULLET",
                upgradeType: .BulletUpgrade,
                description: ["INCREASED DAMAGE", "FASTER BULLET SPEED"],
                cost: Currency(experience: 400, resources: 150),
                rate: rate
            )

            let node = BasePlayerNode()
            node.radarNode.removeFromParent()
            node.rotateUpgrade = rotateUpgrade
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
                cost: Currency(experience: 1000, resources: 150),
                rate: rate
            )

            let node = BasePlayerNode()
            node.radarNode.removeFromParent()
            node.rotateUpgrade = rotateUpgrade
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

    var baseTargetsPreemptively: Bool {
        return self.boolValue
    }

    var baseSweepAngle: CGFloat {
        switch self {
        case .False:   return 30.degrees
        case .True:  return 45.degrees
        }
    }

    var baseRadarRadius: CGFloat {
        switch self {
        case .False:   return 300
        case .True:   return 340
        }
    }

    var baseAngularSpeed: CGFloat {
        switch self {
        case .False: return 4
        case .True: return 10
        }
    }

    var baseAngularAccel: CGFloat? {
        switch self {
        case .False: return 3
        case .True: return 12
        }
    }

    var baseTurretCooldown: CGFloat {
        switch self {
        case .False: return 0.35
        case .True: return 0.25
        }
    }

    var baseBulletSpeed: CGFloat {
        switch self {
        case .False: return rand(weights: (125, 3), (120, 2), (130, 1))
        case .True: return rand(weights: (135, 3), (130, 2), (140, 1))
        }
    }

    var baseBulletDamage: Float {
        switch self {
        case .False: return 1
        case .True: return 2
        }
    }
}
