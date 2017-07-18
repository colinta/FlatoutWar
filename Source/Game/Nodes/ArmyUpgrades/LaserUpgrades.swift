////
///  LaserUpgrades.swift
//


extension LaserNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "TRIODE"
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
    var laserRadarRadius: CGFloat {
        switch self {
        case .false: return 275
        case .true:  return 325
        }
    }
    var laserSweepWidth: CGFloat {
        switch self {
        case .false: return 10
        case .true:  return 18
        }
    }

    var laserAngularSpeed: CGFloat {
        switch self {
        case .false: return 5
        case .true: return 10
        }
    }

    var laserAngularAccel: CGFloat? {
        switch self {
        case .false: return 5
        case .true: return 12
        }
    }

    var laserDamagePerSec: Float {
        switch self {
        case .false: return 4
        case .true:  return 9
        }
    }

    var laserBurnoutUp: CGFloat {
        switch self {
        case .false: return 5.5
        case .true:  return 7.5
        }
    }

    var laserBurnoutDown: CGFloat {
        switch self {
        case .false: return 3
        case .true:  return 3
        }
    }

    var laserRadarColor: Int {
        switch self {
            case .false: return LaserTurretFillColor
            case .true: return LaserTurretFillColor
        }
    }

    var laserMovementSpeed: CGFloat {
        switch self {
        case .false: return 30
        case .true: return 45
        }
    }
}
