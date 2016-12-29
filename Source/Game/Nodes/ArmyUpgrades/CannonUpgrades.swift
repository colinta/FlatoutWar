////
///  CannonUpgrades.swift
//


extension CannonNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "PENTARCHY"
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

    var cannonBulletDamage: Float {
        switch self {
        case .False: return 4
        case .True:  return 6
        }
    }

    var cannonAngularSpeed: CGFloat {
        switch self {
        case .False: return 3
        case .True:  return 6
        }
    }

    var cannonAngularAccel: CGFloat? {
        switch self {
        case .False: return 2
        case .True:  return 8
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
            case .False: return 0xFCF10C
            case .True: return 0xE59311
        }
    }

    var cannonMovementSpeed: CGFloat {
        switch self {
        case .False: return 15
        case .True: return 25
        }
    }
}
