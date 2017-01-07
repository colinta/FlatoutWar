////
///  DroneUpgrades.swift
//


extension DroneNode: UpgradeableNode {
    func upgradeTitle() -> String {
        return "DODEC DRONE"
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

    var droneRadarRadius: CGFloat {
        switch self {
        case .False: return 50
        case .True: return 75
        }
    }

    var droneCooldown: CGFloat {
        switch self {
        case .False: return 0.4
        case .True: return 0.3
        }
    }

    var droneBulletSpeed: CGFloat {
        switch self {
        case .False: return 125
        case .True: return 135
        }
    }

    var droneBulletDamage: Float {
        switch self {
        case .False: return 1
        case .True: return 1.5
        }
    }

    var droneMovementSpeed: CGFloat {
        switch self {
        case .False: return 40
        case .True: return 60
        }
    }

}
