////
///  MissleSiloUpgrades.swift
//


extension MissleSiloNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "HEXAPOD"
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
    var missleSiloRadarRadius: CGFloat {
        switch self {
        case .false: return 40
        case .true:  return 50
        }
    }
    var missleSiloRadarMinDist: CGFloat {
        return 75
    }
    var missleSiloRadarMaxDist: CGFloat {
        switch self {
        case .false: return 150
        case .true:  return 200
        }
    }

    var missleSiloAngularSpeed: CGFloat {
        switch self {
        case .false: return 2
        case .true: return 5
        }
    }

    var missleSiloAngularAccel: CGFloat? {
        switch self {
        case .false: return 2
        case .true: return 6
        }
    }

    var missleSiloBulletDamage: Float {
        switch self {
        case .false: return 5
        case .true:  return 7.5
        }
    }

    var missleSiloBulletSpeed: CGFloat {
        switch self {
        case .false: return 130
        case .true:  return 150
        }
    }

    var missleSiloSplashRadius: Int {
        switch self {
        case .false: return 30
        case .true:  return 40
        }
    }

    var missleSiloCooldown: CGFloat {
        switch self {
        case .false: return 0.25
        case .true:  return 0.15
        }
    }

    var missleSiloRadarColor: Int {
        switch self {
            case .false: return 0xAC1907
            case .true: return 0xDF2E05
        }
    }

    var missleSiloMovementSpeed: CGFloat {
        switch self {
        case .false: return 15
        case .true: return 25
        }
    }

    var missleSiloReloadTime: CGFloat {
        switch self {
        case .false: return 6
        case .true: return 4.5
        }
    }
}
