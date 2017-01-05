////
///  Z.swift
//

enum Z {
    case UITop
    case UI
    case UIBottom
    case Top
    case Above
    case AbovePlayer
    case Player
    case Default
    case BelowPlayer
    case Below
    case Bottom
    case Custom(CGFloat)

    var value: CGFloat {
        switch self {
        case .UITop: return 8
        case .UI: return 7
        case .UIBottom: return 6
        case .Top: return 5
        case .Above: return 4
        case .AbovePlayer: return 3
        case .Player: return 2
        case .Default: return 0
        case .BelowPlayer: return -1
        case .Below: return -2
        case .Bottom: return -4
        case let .Custom(z): return z
        }
    }

    static func above(_ z: Z, by: CGFloat = 0.5) -> Z {
        return .Custom(z.value + by)
    }

    static func below(_ z: Z, by: CGFloat = 0.5) -> Z {
        return .Custom(z.value - by)
    }
}
