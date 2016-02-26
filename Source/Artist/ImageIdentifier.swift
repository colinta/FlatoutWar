//
//  ImageIdentifier.swift
//  FlatoutWar
//
//  Created by Colin Gray on 10/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum ImageIdentifier {
    enum Size {
        case Small
        case Big

        var name: String { return "\(self)" }
    }

    enum EnemyType {
        case Soldier
        case Leader
        case Scout
        case Dozer
        case GiantSoldier

        case Jet
        case BigJet

        var name: String { return "\(self)" }
    }

    enum PowerupType {
        case Decoy
        case Mines
        case Grenade
        case Bomber
        case Shield
        case Soldiers
        case Hourglass
        case Pulse
        case Laser
        case Net
        case Coffee

        var name: String { return "\(self)" }
    }

    case None
    case WhiteLetter(String, size: Size)
    case Letter(String, size: Size, color: Int)
    case Button(style: ButtonStyle)
    case Percent(Int, style: PercentStyle)

    case Enemy(type: EnemyType, health: Int)
    case EnemyShrapnel(type: EnemyType, size: Size)

    case Powerup(type: PowerupType)
    case NoPowerup
    case Bomber(numBombs: Int)
    case Bomb(radius: Int, time: Int)
    case HourglassZone
    case Mine
    case MineExplosion
    case Net

    case Drone(upgrade: FiveUpgrades, health: Int)

    case Cursor
    case Base(upgrade: FiveUpgrades, health: Int)
    case BaseRadar(upgrade: FiveUpgrades)
    case BaseExplosion(index: Int, total: Int)

    case BaseSingleTurret(upgrade: FiveUpgrades)
    case BaseDoubleTurret(upgrade: FiveUpgrades)
    case BaseBigTurret(upgrade: FiveUpgrades)
    case BaseTurretBullet(upgrade: FiveUpgrades)

    case ColorPath(path: UIBezierPath, color: Int)
    case ColorLine(length: CGFloat, color: Int)
    case HueLine(length: CGFloat, hue: Int)
    case ColorBox(size: CGSize, color: Int)
    case HueBox(size: CGSize, hue: Int)
    case FillColorBox(size: CGSize, color: Int)
    case FillHueBox(size: CGSize, hue: Int)

    var name: String? {
        switch self {
        case .None:
            return ""
        case let .Percent(percent, style):
            return "Percent-percent_\(percent)-style_\(style)"
        case let .WhiteLetter(letter, size):
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
            return "WhiteLetter-letter_\(nameLetter)-size_\(size.name)"
        case let .Letter(letter, size, color):
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
            return "Letter-letter_\(nameLetter)-size_\(size.name)-color_\(color)"
        case let .Button(style):
            return "Button-style_\(style.name)"
        case let .Enemy(type, health):
            return "Enemy-type_\(type.name)-health_\(health)"
        case let .EnemyShrapnel(type, size):
            return "EnemyShrapnel-type_\(type.name)-size_\(size.name)"
        case let .Powerup(type):
            return "Powerup-type_\(type.name)"
        case .NoPowerup:
            return "NoPowerup"
        case let .Bomber(numBombs):
            return "Bomber-numBombs_\(numBombs)"
        case let .Bomb(radius, time):
            return "Bomb-radius_\(radius)-time_\(time)"
        case .HourglassZone:
            return "HourglassZone"
        case .Mine:
            return "Mine"
        case .MineExplosion:
            return "MineExplosion"
        case .Net:
            return "Net"
        case let .Drone(upgrade, health):
            return "Drone-upgrade_\(upgrade.name)-health_\(health)"
        case .Cursor:
            return "Cursor"
        case let .Base(upgrade, health):
            return "Base-upgrade_\(upgrade.name)-health_\(health)"
        case let .BaseRadar(upgrade):
            return "BaseRadar-upgrade_\(upgrade.name)"
        case let .BaseExplosion(index, total):
            return "BaseExplosion-index_\(index)-total_\(total)"
        case let .BaseSingleTurret(upgrade):
            return "BaseSingleTurret-upgrade_\(upgrade.name)"
        case let .BaseDoubleTurret(upgrade):
            return "BaseDoubleTurret-upgrade_\(upgrade.name)"
        case let .BaseBigTurret(upgrade):
            return "BaseBigTurret-upgrade_\(upgrade.name)"
        case let .BaseTurretBullet(upgrade):
            return "BaseTurretBullet-upgrade_\(upgrade.name)"
        case .ColorPath:
            return nil
        case let .ColorLine(length, color):
            let roundedLength = Int(round(length * 20))
            return "ColorLine-length_\(roundedLength)-color_\(color)"
        case let .HueLine(length, hue):
            let roundedLength = Int(round(length * 20))
            return "HueLine-length_\(roundedLength)-hue_\(hue)"
        case let .ColorBox(size, color):
            return "ColorBox-size\(Int(size.width))x\(Int(size.height))-color_\(color)"
        case let .HueBox(size, hue):
            return "HueBox-size\(Int(size.width))x\(Int(size.height))-hue_\(hue)"
        case let .FillColorBox(size, color):
            return "FillColorBox-size\(Int(size.width))x\(Int(size.height))-color_\(color)"
        case let .FillHueBox(size, hue):
            return "FillHueBox-size\(Int(size.width))x\(Int(size.height))-hue_\(hue)"
        }
    }
}
