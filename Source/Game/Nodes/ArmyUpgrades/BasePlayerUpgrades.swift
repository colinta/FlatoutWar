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
        case .MovementUpgrade:
            movementUpgrade = true
        }
    }

    func availableUpgrades(world upgradeWorld: World) -> [(ArmyUpgradeButton, UpgradeInfo)] {
        var upgrades: [(ArmyUpgradeButton, UpgradeInfo)] = []

        var rate: CGFloat = 2.5
        if radarUpgrade.boolValue { rate -= 0.1 }
        if movementUpgrade.boolValue { rate -= 0.3 }
        if bulletUpgrade.boolValue { rate -= 0.3 }

        do {
            let info = UpgradeInfo(
                title: "SPEED",
                upgradeType: .MovementUpgrade,
                description: ["INCREASED SPEED", "FASTER FIRING"],
                cost: Currency(experience: 450, resources: 150),
                rate: rate
            )

            let node = BasePlayerNode()
            node.radarSprite.removeFromParent()
            node.movementUpgrade = .True
            node.radarUpgrade = radarUpgrade
            node.bulletUpgrade = bulletUpgrade

            let button = ArmyUpgradeButton(node: node, info: info)
            button.upgradeEnabled = !movementUpgrade.boolValue

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
            node.radarSprite.removeFromParent()
            node.movementUpgrade = movementUpgrade
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
            node.radarSprite.removeFromParent()
            node.movementUpgrade = movementUpgrade
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
        case .False: return 125
        case .True: return 135
        }
    }

    var baseBulletDamage: Float {
        switch self {
        case .False: return 1
        case .True: return 2
        }
    }

    var baseRadarColor: Int {
        switch self {
            case .False: return BaseRadar1Color
            case .True: return BaseRadar2Color
        }
    }
}
