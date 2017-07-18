////
///  CannonUpgrades.swift
//


extension CannonNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "PENTARCH"
    }

    func applyUpgrade(type: UpgradeType) {
        switch type {
        case .radarUpgrade:
            radarUpgrade = true
        case .bulletUpgrade:
            bulletUpgrade = true
        case .movementUpgrade:
            movementUpgrade = true
        }
    }
}


extension HasUpgrade {
    var cannonSweepAngle: CGFloat {
        switch self {
        case .false: return 30.degrees
        case .true:  return 40.degrees
        }
    }

    var cannonMinRadarRadius: CGFloat {
        return 150
    }

    var cannonMaxRadarRadius: CGFloat {
        switch self {
        case .false: return 200
        case .true:  return 250
        }
    }

    var cannonAngularSpeed: CGFloat {
        switch self {
        case .false: return 3
        case .true: return 7
        }
    }

    var cannonAngularAccel: CGFloat? {
        return nil
    }

    var cannonBulletDamage: Float {
        switch self {
        case .false: return 4
        case .true:  return 6
        }
    }

    var cannonBulletSpeed: CGFloat {
        switch self {
        case .false: return 115
        case .true:  return 140
        }
    }

    var cannonSplashRadius: Int {
        switch self {
        case .false: return 18
        case .true:  return 25
        }
    }

    var cannonCooldown: CGFloat {
        switch self {
        case .false: return 1.4
        case .true:  return 1
        }
    }

    var cannonRadarColor: Int {
        switch self {
            case .false: return CannonRadar1Color
            case .true: return CannonRadar2Color
        }
    }

    var cannonMovementSpeed: CGFloat {
        switch self {
        case .false: return 15
        case .true: return 25
        }
    }
}
