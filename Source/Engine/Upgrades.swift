////
///  Upgrades.swift
//

enum HasUpgrade {
    case False
    case True

    init(safe val: Bool?) {
        switch val {
        case .Some(true): self = .True
        case .None, .Some(false): self = .False
        }
    }

    var name: String {
        return "\(self == .True)"
    }
}

extension HasUpgrade: BooleanLiteralConvertible {
    init(booleanLiteral value: Bool) {
        self = value ? .True : .False
    }
}

extension HasUpgrade: BooleanType {
    var boolValue: Bool { return self == .True }
}

enum UpgradeType {
    case Upgrade
    case RadarUpgrade
    case TurretUpgrade
}

typealias UpgradeInfo = (upgradeNode: SKNode, cost: Int, upgradeType: UpgradeType)
