////
///  Upgrades.swift
//

enum HasUpgrade {
    case `false`
    case `true`

    init(safe val: Bool?) {
        switch val {
        case .some(true): self = .true
        case .none, .some(false): self = .false
        }
    }

    var name: String {
        return "\(self == .true)"
    }
}

extension HasUpgrade: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .true : .false
    }
}

extension HasUpgrade {
    var boolValue: Bool { return self == .true }
}

extension HasUpgrade {
    var targetsPreemptively: Bool {
        return self.boolValue
    }
}
