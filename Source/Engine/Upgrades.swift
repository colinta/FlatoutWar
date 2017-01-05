////
///  Upgrades.swift
//

enum HasUpgrade {
    case False
    case True

    init(safe val: Bool?) {
        switch val {
        case .some(true): self = .True
        case .none, .some(false): self = .False
        }
    }

    var name: String {
        return "\(self == .True)"
    }
}

extension HasUpgrade: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .True : .False
    }
}

extension HasUpgrade {
    var boolValue: Bool { return self == .True }
}

extension HasUpgrade {
    var targetsPreemptively: Bool {
        return self.boolValue
    }
}

enum UpgradeType {
    case RadarUpgrade
    case BulletUpgrade
    case MovementUpgrade
}
