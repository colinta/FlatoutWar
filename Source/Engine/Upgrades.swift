//
//  Upgrades.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum FiveUpgrades: IntValue {
    static let Default = FiveUpgrades.One
    case One
    case Two
    case Three
    case Four
    case Five

    init(_ val: Int) {
        switch val {
        case 1: self = .One
        case 2: self = .Two
        case 3: self = .Three
        case 4: self = .Four
        case 5: self = .Five
        default: self = .Default
        }
    }

    var int: Int {
        switch self {
        case One: return 1
        case Two: return 2
        case Three: return 3
        case Four: return 4
        case Five: return 5
        }
    }

    var name: String {
        return "\(self)"
    }

    var canUpgrade: Bool {
        switch self {
        case Five: return false
        default: return true
        }
    }

    var next: FiveUpgrades {
        switch self {
        case One: return .Two
        case Two: return .Three
        case Three: return .Four
        case Four: return .Five
        case Five: return .Five
        }
    }

    var cost: Int {
        switch self {
        case One: return 10
        case Two: return 25
        case Three: return 50
        case Four: return 100
        case Five: return 0
        }
    }
}
