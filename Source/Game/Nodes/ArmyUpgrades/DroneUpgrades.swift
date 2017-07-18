////
///  DroneUpgrades.swift
//


extension DroneNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "DODEC DRONE"
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

    var droneRadarRadius: CGFloat {
        switch self {
        case .false: return 70
        case .true: return 80
        }
    }

    var droneCooldown: CGFloat {
        switch self {
        case .false: return 0.4
        case .true: return 0.3
        }
    }

    var droneBulletSpeed: CGFloat {
        switch self {
        case .false: return 125
        case .true: return 135
        }
    }

    var droneBulletDamage: Float {
        switch self {
        case .false: return 1
        case .true: return 1.25
        }
    }

    var droneMovementSpeed: CGFloat {
        switch self {
        case .false: return 40
        case .true: return 60
        }
    }

}
