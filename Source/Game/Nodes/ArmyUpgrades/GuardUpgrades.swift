////
///  GuardUpgrades.swift
//


extension GuardNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "SEPTENTRION"
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
    var shotgunRadarRadius: CGFloat {
        switch self {
        case .false: return 75
        case .true:  return 90
        }
    }

    var shotgunSweepAngle: CGFloat {
        return TAU_3_8
    }

    var shotgunAngularSpeed: CGFloat {
        switch self {
        case .false: return 8
        case .true: return 14
        }
    }

    var shotgunAngularAccel: CGFloat? {
        switch self {
        case .false: return 6
        case .true: return nil
        }
    }

    var shotgunBulletDamage: Float {
        switch self {
        case .false: return 0.25
        case .true:  return 0.75
        }
    }

    var shotgunBulletSpeed: CGFloat {
        switch self {
        case .false: return 140
        case .true: return 155
        }
    }

    var shotgunSlowCooldown: CGFloat {
        switch self {
        case .false: return 1
        case .true:  return 0.8
        }
    }
    var shotgunFastCooldown: CGFloat {
        switch self {
        case .false: return 0.25
        case .true:  return 0.15
        }
    }

    var shotgunScanSpinRate: CGFloat {
        switch self {
        case .false: return 0.2
        case .true: return 0.4
        }
    }

    var shotgunTurretSlowSpinRate: CGFloat {
        switch self {
        case .false: return 1
        case .true: return -1.5
        }
    }

    var shotgunTurretFastSpinRate: CGFloat {
        switch self {
        case .false: return 8
        case .true: return -11
        }
    }

    var shotgunWarmupRate: CGFloat {
        switch self {
        case .false: return 6
        case .true:  return 12
        }
    }

    var shotgunBaseColor: Int {
        switch self {
            case .false: return GuardBaseColor
            case .true: return GuardUpgradeColor
        }
    }
    var shotgunRadarColor: Int {
        switch self {
            case .false: return GuardRadar1Color
            case .true: return GuardRadar2Color
        }
    }

    var shotgunMovementSpeed: CGFloat {
        switch self {
        case .false: return 50
        case .true: return 75
        }
    }
}
