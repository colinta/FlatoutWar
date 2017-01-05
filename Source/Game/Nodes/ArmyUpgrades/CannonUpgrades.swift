////
///  CannonUpgrades.swift
//


extension CannonNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "PENTARCH"
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
        return []
    }
}


extension HasUpgrade {
    var cannonSweepAngle: CGFloat {
        switch self {
        case .False: return 30.degrees
        case .True:  return 40.degrees
        }
    }

    var cannonMinRadarRadius: CGFloat {
        return 150
    }

    var cannonMaxRadarRadius: CGFloat {
        switch self {
        case .False: return 200
        case .True:  return 250
        }
    }

    var cannonAngularSpeed: CGFloat {
        switch self {
        case .False: return 3
        case .True: return 7
        }
    }

    var cannonAngularAccel: CGFloat? {
        return nil
    }

    var cannonBulletDamage: Float {
        switch self {
        case .False: return 4
        case .True:  return 6
        }
    }

    var cannonBulletSpeed: CGFloat {
        switch self {
        case .False: return 115
        case .True:  return 140
        }
    }

    var cannonSplashRadius: Int {
        switch self {
        case .False: return 18
        case .True:  return 25
        }
    }

    var cannonCooldown: CGFloat {
        switch self {
        case .False: return 1.4
        case .True:  return 1
        }
    }

    var cannonRadarColor: Int {
        switch self {
            case .False: return CannonRadar1Color
            case .True: return CannonRadar2Color
        }
    }

    var cannonMovementSpeed: CGFloat {
        switch self {
        case .False: return 15
        case .True: return 25
        }
    }
}
