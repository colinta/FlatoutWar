////
///  Mod.swift
//

enum Attr {
    case TimeRate
    case Halted
}

enum AttrMod {
    case TimeRate(CGFloat)
    case Halted(Bool)

    var timeRate: CGFloat {
        if case let .TimeRate(timeRate) = self {
            return timeRate
        }
        return 0
    }
}

struct Mod {
    let id = NSUUID()
    let attr: AttrMod
}


extension Mod: Equatable {}

func ==(lhs: Mod, rhs: Mod) -> Bool {
    return lhs.id.uuidString == rhs.id.uuidString
}
