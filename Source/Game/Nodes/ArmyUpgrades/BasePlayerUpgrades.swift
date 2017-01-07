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
