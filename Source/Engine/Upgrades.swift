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
    var boolValue: Bool { return self == .true }
    var targetsPreemptively: Bool {
        return self.boolValue
    }
}
