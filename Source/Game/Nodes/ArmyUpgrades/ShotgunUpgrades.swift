////
///  ShotgunUpgrades.swift
//


extension ShotgunNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "SEPTENTRION"
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
    var shotgunRadarRadius: CGFloat {
        switch self {
        case .False: return 75
        case .True:  return 90
        }
    }

    var shotgunSweepAngle: CGFloat {
        return TAU_3_8
    }

    var shotgunAngularSpeed: CGFloat {
        switch self {
        case .False: return 8
        case .True: return 14
        }
    }

    var shotgunAngularAccel: CGFloat? {
        switch self {
        case .False: return 6
        case .True: return nil
        }
    }

    var shotgunBulletDamage: Float {
        switch self {
        case .False: return 0.25
        case .True:  return 0.75
        }
    }

    var shotgunBulletSpeed: CGFloat {
        switch self {
        case .False: return 140
        case .True: return 155
        }
    }

    var shotgunSlowCooldown: CGFloat {
        switch self {
        case .False: return 1
        case .True:  return 0.8
        }
    }
    var shotgunFastCooldown: CGFloat {
        switch self {
        case .False: return 0.25
        case .True:  return 0.15
        }
    }

    var shotgunScanSpinRate: CGFloat {
        switch self {
        case .False: return 0.2
        case .True: return 0.4
        }
    }

    var shotgunTurretSlowSpinRate: CGFloat {
        switch self {
        case .False: return 1
        case .True: return -1.5
        }
    }

    var shotgunTurretFastSpinRate: CGFloat {
        switch self {
        case .False: return 8
        case .True: return -11
        }
    }

    var shotgunWarmupRate: CGFloat {
        switch self {
        case .False: return 6
        case .True:  return 12
        }
    }

    var shotgunBaseColor: Int {
        switch self {
            case .False: return ShotgunBaseColor
            case .True: return ShotgunUpgradeColor
        }
    }
    var shotgunRadarColor: Int {
        switch self {
            case .False: return ShotgunRadar1Color
            case .True: return ShotgunRadar2Color
        }
    }

    var shotgunMovementSpeed: CGFloat {
        switch self {
        case .False: return 50
        case .True: return 75
        }
    }
}
