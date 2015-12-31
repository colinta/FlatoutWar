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
    case Cursor
    case Drawer
    case Drone(upgrade: FiveUpgrades)
    case Radar(upgrade: FiveUpgrades)
    case Base(upgrade: FiveUpgrades, health: Float)
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
            case "!":
                nameLetter = "bang"
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
        case .Cursor:
            return "Cursor"
        case let .Drone(upgrade):
            return "Drone-upgrade_\(upgrade.name)"
        case let .Radar(upgrade):
            return "Radar-upgrade_\(upgrade.name)"
        case let .Base(upgrade, health):
            return "Base-upgrade_\(upgrade.name)-health_\(round(health * 360))"
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
