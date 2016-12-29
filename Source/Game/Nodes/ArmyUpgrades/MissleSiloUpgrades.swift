////
///  MissleSiloUpgrades.swift
//


extension MissleSiloNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "HEXAPOD"
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
    var missleSiloRadarRadius: CGFloat {
        switch self {
        case .False: return 40
        case .True:  return 50
        }
    }
    var missleSiloRadarMinDist: CGFloat {
        return 75
    }
    var missleSiloRadarMaxDist: CGFloat {
        switch self {
        case .False: return 150
        case .True:  return 200
        }
    }

    var missleSiloBulletDamage: Float {
        switch self {
        case .False: return 5
        case .True:  return 7.5
        }
    }

    var missleSiloBulletSpeed: CGFloat {
        switch self {
        case .False: return 130
        case .True:  return 150
        }
    }

    var missleSiloSplashRadius: Int {
        switch self {
        case .False: return 30
        case .True:  return 40
        }
    }

    var missleSiloCooldown: CGFloat {
        switch self {
        case .False: return 0.25
        case .True:  return 0.15
        }
    }

    var missleSiloRadarColor: Int {
        switch self {
            case .False: return 0xAC1907
            case .True: return 0xDF2E05
        }
    }

    var missleSiloMovementSpeed: CGFloat {
        switch self {
        case .False: return 15
        case .True: return 25
        }
    }

    var missleSiloReloadTime: CGFloat {
        switch self {
        case .False: return 6
        case .True: return 4.5
        }
    }
}
