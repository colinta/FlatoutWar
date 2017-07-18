////
///  BasePlayerUpgrades.swift
//

extension BasePlayerNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "ICOSAGON"
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

    var baseTargetsPreemptively: Bool {
        return self.boolValue
    }

    var baseSweepAngle: CGFloat {
        switch self {
        case .false:   return 30.degrees
        case .true:  return 45.degrees
        }
    }

    var baseRadarRadius: CGFloat {
        switch self {
        case .false:   return 300
        case .true:   return 340
        }
    }

    var baseAngularSpeed: CGFloat {
        switch self {
        case .false: return 4
        case .true: return 10
        }
    }

    var baseAngularAccel: CGFloat? {
        switch self {
        case .false: return 3
        case .true: return 12
        }
    }

    var baseTurretCooldown: CGFloat {
        switch self {
        case .false: return 0.35
        case .true: return 0.25
        }
    }

    var baseBulletSpeed: CGFloat {
        switch self {
        case .false: return 125
        case .true: return 135
        }
    }

    var baseBulletDamage: Float {
        switch self {
        case .false: return 1
        case .true: return 2
        }
    }

    var baseRadarColor: Int {
        switch self {
            case .false: return BaseRadar1Color
            case .true: return BaseRadar2Color
        }
    }
}
