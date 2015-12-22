//
//  ImageIdentifier.swift
//  FlatoutWar
//
//  Created by Colin Gray on 10/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum ImageIdentifier {
    enum LetterSize {
        case Small
        case Big

        var name: String { return "\(self)" }
    }

    enum ButtonType {
        case Circle
        case Play
        case Setup
        case Pause
        case Resume
        case Restart
        case Quit
        case Back
        case Next
        case Prev
        case Level(Int)

        var name: String { return "\(self)" }
    }

    enum EnemyType {
        case Soldier
        case Leader
        case Scout
        case Dozer

        var name: String { return "\(self)" }
    }

    case Letter(String, size: LetterSize)
    case Button(type: ButtonType, touched: Bool)
    case Enemy(type: EnemyType)
    case EnemyShrapnel(type: EnemyType)
    case Cursor(selected: Bool)
    case Drawer
    case Drone(upgrade: FiveUpgrades)
    case Radar(upgrade: FiveUpgrades)
    case Base(upgrade: FiveUpgrades)
    case BaseSingleTurret(upgrade: FiveUpgrades)
    case BaseDoubleTurret(upgrade: FiveUpgrades)
    case BaseBigTurret(upgrade: FiveUpgrades)
    case BaseTurretBullet(upgrade: FiveUpgrades)

    case Explosion
    case EnemyExplosion
    case PlayerExplosion

    var name: String {
        switch self {
        case let .Letter(letter, size):
            let nameLetter: String
            switch letter {
            case ".":
                nameLetter = "dot"
            case "-":
                nameLetter = "dash"
            case "_":
                nameLetter = "lodash"
            case "<":
                nameLetter = "lt"
            case ">":
                nameLetter = "gt"
            default:
                nameLetter = letter
            }
            return "Letter-letter_\(nameLetter)-size_\(size.name)"
        case let .Button(type, touched):
            return "Button-type_\(type.name)-touched_\(touched)"
        case let .Enemy(type):
            return "Enemy-type_\(type.name)"
        case let .EnemyShrapnel(type):
            return "EnemyShrapnel-type_\(type.name)"
        case let .Cursor(selected):
            return "Cursor-selected_\(selected)"
        case let .Drone(upgrade):
            return "Drone-upgrade_\(upgrade.name)"
        case let .Radar(upgrade):
            return "Radar-upgrade_\(upgrade.name)"
        case let .Base(upgrade):
            return "Base-upgrade_\(upgrade.name)"
        case let .BaseSingleTurret(upgrade):
            return "BaseSingleTurret-upgrade_\(upgrade.name)"
        case let .BaseDoubleTurret(upgrade):
            return "BaseDoubleTurret-upgrade_\(upgrade.name)"
        case let .BaseBigTurret(upgrade):
            return "BaseBigTurret-upgrade_\(upgrade.name)"
        case let .BaseTurretBullet(upgrade):
            return "BaseTurretBullet-upgrade_\(upgrade.name)"
        default:
            return "\(self)"
        }
    }
}

protocol IntValue {
    var int: Int { get }
}

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

func <(upgrade: IntValue, int: Int) -> Bool {
    return upgrade.int < int
}

func <=(upgrade: IntValue, int: Int) -> Bool {
    return upgrade.int <= int
}

func >(upgrade: IntValue, int: Int) -> Bool {
    return upgrade.int > int
}

func >=(upgrade: IntValue, int: Int) -> Bool {
    return upgrade.int >= int
}

func <(int: Int, upgrade: IntValue) -> Bool {
    return int < upgrade.int
}

func <=(int: Int, upgrade: IntValue) -> Bool {
    return int <= upgrade.int
}

func >(int: Int, upgrade: IntValue) -> Bool {
    return int > upgrade.int
}

func >=(int: Int, upgrade: IntValue) -> Bool {
    return int >= upgrade.int
}
