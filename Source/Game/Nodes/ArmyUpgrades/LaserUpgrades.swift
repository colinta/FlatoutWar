////
///  LaserUpgrades.swift
//


extension LaserNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "TRIODE"
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
    var laserRadarRadius: CGFloat {
        switch self {
        case .False: return 275
        case .True:  return 325
        }
    }
    var laserSweepWidth: CGFloat {
        switch self {
        case .False: return 10
        case .True:  return 18
        }
    }

    var laserAngularSpeed: CGFloat {
        switch self {
        case .False: return 5
        case .True: return 10
        }
    }

    var laserAngularAccel: CGFloat? {
        switch self {
        case .False: return 5
        case .True: return 12
        }
    }

    var laserDamagePerSec: Float {
        switch self {
        case .False: return 4
        case .True:  return 9
        }
    }

    var laserBurnoutUp: CGFloat {
        switch self {
        case .False: return 5.5
        case .True:  return 7.5
        }
    }

    var laserBurnoutDown: CGFloat {
        switch self {
        case .False: return 3
        case .True:  return 3
        }
    }

    var laserRadarColor: Int {
        switch self {
            case .False: return LaserTurretFillColor
            case .True: return LaserTurretFillColor
        }
    }

    var laserMovementSpeed: CGFloat {
        switch self {
        case .False: return 30
        case .True: return 45
        }
    }
}
