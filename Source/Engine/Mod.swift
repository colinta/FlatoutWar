//
//  Mod.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/24/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
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
    return lhs.id.UUIDString == rhs.id.UUIDString
}
