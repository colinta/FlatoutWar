////
///  Z.swift
//

enum Z {
    case uiTop
    case ui
    case uiBottom
    case top
    case above
    case abovePlayer
    case player
    case `default`
    case belowPlayer
    case below
    case bottom
    case custom(CGFloat)

    var value: CGFloat {
        switch self {
        case .uiTop: return 8
        case .ui: return 7
        case .uiBottom: return 6
        case .top: return 5
        case .above: return 4
        case .abovePlayer: return 3
        case .player: return 2
        case .default: return 0
        case .belowPlayer: return -1
        case .below: return -2
        case .bottom: return -4
        case let .custom(z): return z
        }
    }

    static func zAbove(_ z: Z, by: CGFloat = 0.5) -> Z {
        return .custom(z.value + by)
    }

    static func zBelow(_ z: Z, by: CGFloat = 0.5) -> Z {
        return .custom(z.value - by)
    }
}
