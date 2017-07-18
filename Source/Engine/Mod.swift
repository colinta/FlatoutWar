////
///  Mod.swift
//

enum Attr {
    case timeRate
    case halted
}

enum AttrMod {
    case timeRate(CGFloat)
    case halted(Bool)

    var timeRate: CGFloat {
        if case let .timeRate(timeRate) = self {
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
