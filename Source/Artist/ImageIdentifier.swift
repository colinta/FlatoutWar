//
//  ImageIdentifier.swift
//  FlatoutWar
//
//  Created by Colin Gray on 10/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

indirect enum ImageIdentifier {
    enum Size {
        case Tiny
        case Small
        case Big
        case Actual

        var name: String { return "\(self)" }
    }

    enum EnemyType {
        case Soldier
        case SlowSoldier
        case FastSoldier
        case Leader
        case Scout
        case Dozer
        case GiantSoldier

        case Jet
        case BigJet
        case JetTransport

        case Diamond

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
    case Dot(color: Int)
    case Box(color: Int)
    case Warning
    case WhiteLetter(String, size: Size)
    case Letter(String, size: Size, color: Int)
    case Button(style: ButtonStyle)
    case Percent(Int, style: PercentStyle)

    case Enemy(EnemyType, health: Int)
    case EnemyShrapnel(ImageIdentifier, size: Size)

    case Powerup(type: PowerupType)
    case NoPowerup
    case Bomber(numBombs: Int)
    case Bomb(radius: Int, time: Int)
    case HourglassZone
    case Mine
    case MineExplosion
    case Net(phase: Int)
    case EnemyNet(size: CGFloat)
    case Shield(phase: Int)
    case ShieldSegment(health: Int)
    case Soldier(health: Int)
    case PowerupTimer(percent: Int)

    case Drone(upgrade: FiveUpgrades, health: Int)
    case Turret(upgrade: FiveUpgrades, health: Int)
    case TurretRadar(upgrade: FiveUpgrades)
    case Resource(goal: Int, remaining: Int)
    case ResourceLine(length: CGFloat)

    case Cursor
    case Base(upgrade: FiveUpgrades, health: Int)
    case BaseRadar(upgrade: FiveUpgrades)
    case BaseExplosion(index: Int, total: Int)

    case BaseSingleTurret(upgrade: FiveUpgrades)
    case BaseRapidTurret(upgrade: FiveUpgrades)
    case BaseDoubleTurret(upgrade: FiveUpgrades)
    case BaseBigTurret(upgrade: FiveUpgrades)
    case BaseTurretBullet(upgrade: FiveUpgrades, style: BulletNode.Style)

    case ColorPath(path: UIBezierPath, color: Int)
    case ColorLine(length: CGFloat, color: Int)
    case HueLine(length: CGFloat, hue: Int)
    case ColorCircle(size: CGSize, color: Int)
    case ColorBox(size: CGSize, color: Int)
    case HueBox(size: CGSize, hue: Int)
    case FillColorCircle(size: CGSize, color: Int)
    case FillColorBox(size: CGSize, color: Int)
    case FillHueBox(size: CGSize, hue: Int)

    var name: String? {
        switch self {
        case .None:
            return ""
        case .Warning:
            return "Warning()"
        case let .Dot(color):
            return "Dot(color:\(color))"
        case let .Box(color):
            return "Box(color:\(color))"
        case let .Percent(percent, style):
            return "Percent(percent:\(percent),style:\(style))"
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
            return "WhiteLetter(letter:\(nameLetter),size:\(size.name))"
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
            return "Letter(letter:\(nameLetter),size:\(size.name),color:\(color))"
        case let .Button(style):
            return "Button(style:\(style.name))"
        case let .Enemy(type, health):
            return "Enemy(type:\(type.name),health:\(health))"
        case let .EnemyShrapnel(type, size):
            return "EnemyShrapnel(type:\(type.name),size:\(size.name))"
        case let .Powerup(type):
            return "Powerup(type:\(type.name))"
        case .NoPowerup:
            return "NoPowerup"
        case let .Bomber(numBombs):
            return "Bomber(numBombs:\(numBombs))"
        case let .Bomb(radius, time):
            return "Bomb(radius:\(radius),time:\(time))"
        case .HourglassZone:
            return "HourglassZone"
        case .Mine:
            return "Mine"
        case .MineExplosion:
            return "MineExplosion"
        case let .Net(phase):
            return "Net(phase:\(phase))"
        case let .EnemyNet(size):
            let roundedSize = Int(round(size * 20))
            return "EnemyNet(size:\(roundedSize))"
        case let .Soldier(health):
            return "Soldier(health:\(health))"
        case let .PowerupTimer(percent):
            return "PowerupTimer(percent:\(percent))"
        case let .Drone(upgrade, health):
            return "Drone(upgrade:\(upgrade.name),health:\(health))"
        case let .Turret(upgrade, health):
            return "Turret(upgrade:\(upgrade.name),health:\(health))"
        case let .TurretRadar(upgrade):
            return "TurretRadar(upgrade:\(upgrade.name))"
        case .Cursor:
            return "Cursor"
        case let .Resource(amount, remaining):
            return "Resource(amount:\(amount),remaining:\(remaining))"
        case let .ResourceLine(length):
            let roundedLength = Int(round(length * 20))
            return "ResourceLine(length:\(roundedLength))"
        case let .Shield(phase):
            return "Shield(phase:\(phase))"
        case let .ShieldSegment(health):
            return "ShieldSegment(health:\(health))"
        case let .Base(upgrade, health):
            return "Base(upgrade:\(upgrade.name),health:\(health))"
        case let .BaseRadar(upgrade):
            return "BaseRadar(upgrade:\(upgrade.name))"
        case let .BaseExplosion(index, total):
            return "BaseExplosion(index:\(index),total:\(total))"
        case let .BaseSingleTurret(upgrade):
            return "BaseSingleTurret(upgrade:\(upgrade.name))"
        case let .BaseRapidTurret(upgrade):
            return "BaseRapidTurret(upgrade:\(upgrade.name))"
        case let .BaseDoubleTurret(upgrade):
            return "BaseDoubleTurret(upgrade:\(upgrade.name))"
        case let .BaseBigTurret(upgrade):
            return "BaseBigTurret(upgrade:\(upgrade.name))"
        case let .BaseTurretBullet(upgrade, style):
            return "BaseTurretBullet(upgrade:\(upgrade.name),style:\(style))"
        case .ColorPath:
            return nil
        case let .ColorLine(length, color):
            let roundedLength = Int(round(length * 20))
            return "ColorLine(length:\(roundedLength),color:\(color))"
        case let .HueLine(length, hue):
            let roundedLength = Int(round(length * 20))
            return "HueLine(length:\(roundedLength),hue:\(hue))"
        case let .ColorCircle(size, color):
            return "ColorCircle(size\(Int(size.width))x\(Int(size.height)),color:\(color))"
        case let .ColorBox(size, color):
            return "ColorBox(size\(Int(size.width))x\(Int(size.height)),color:\(color))"
        case let .HueBox(size, hue):
            return "HueBox(size\(Int(size.width))x\(Int(size.height)),hue:\(hue))"
        case let .FillColorCircle(size, color):
            return "FillColorCircle(size\(Int(size.width))x\(Int(size.height)),color:\(color))"
        case let .FillColorBox(size, color):
            return "FillColorBox(size\(Int(size.width))x\(Int(size.height)),color:\(color))"
        case let .FillHueBox(size, hue):
            return "FillHueBox(size\(Int(size.width))x\(Int(size.height)),hue:\(hue))"
        }
    }
}
