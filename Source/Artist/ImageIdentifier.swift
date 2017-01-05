////
///  ImageIdentifier.swift
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
    case ResourceIcon
    case ExperienceIcon
    case Box(color: Int)
    case Warning
    case WhiteLetter(String, size: Size)
    case Letter(String, size: Size, color: Int)
    case Button(style: ButtonStyle, color: Int)
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

    case Drone(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case DroneRadar(upgrade: HasUpgrade)

    case LaserNode(upgrade: HasUpgrade, health: Int)
    case LaserTurret(upgrade: HasUpgrade, isFiring: Bool)
    case LaserRadar(upgrade: HasUpgrade, isSelected: Bool)

    case ShotgunNode(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case ShotgunTurret(upgrade: HasUpgrade)
    case ShotgunRadar(upgrade: HasUpgrade, isSelected: Bool)

    case Cannon(upgrade: HasUpgrade, health: Int)
    case CannonBox(upgrade: HasUpgrade)
    case CannonTurret(upgrade: HasUpgrade)
    case CannonRadar(upgrade: HasUpgrade, isSelected: Bool)

    case MissleSilo(upgrade: HasUpgrade, health: Int)
    case MissleSiloBox(upgrade: HasUpgrade)
    case MissleSiloRadar(upgrade: HasUpgrade, isSelected: Bool)
    case Missle

    case Resource(goal: Int, remaining: Int)
    case ResourceLine(length: CGFloat)

    case Cursor
    case Base(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case BaseRadar(upgrade: HasUpgrade, isSelected: Bool)
    case BaseExplosion(index: Int, total: Int)

    case BaseSingleTurret(bulletUpgrade: HasUpgrade)
    case BaseRapidTurret(bulletUpgrade: HasUpgrade)
    case BaseDoubleTurret(bulletUpgrade: HasUpgrade)
    case BaseBigTurret(bulletUpgrade: HasUpgrade)
    case Bullet(upgrade: HasUpgrade, style: BulletNode.Style)

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
            return "None"
        case .Warning:
            return "Warning"
        case let .Dot(color):
            return "Dot_color-\(color)"
        case .ResourceIcon:
            return "ResourceIcon"
        case .ExperienceIcon:
            return "ExperienceIcon"
        case let .Box(color):
            return "Box_color-\(color)"
        case let .Percent(percent, style):
            return "Percent_percent-\(percent)_style-\(style)"
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
            return "WhiteLetter_letter-\(nameLetter)_size-\(size.name)"
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
            return "Letter_\(nameLetter)_size-\(size.name)_color-\(color)"
        case let .Button(style, color):
            return "Button_style-\(style.name)_color-\(color)"
        case let .Enemy(type, health):
            let typeName = type.name
            return "Enemy_type-(\(typeName))_health-\(health)"
        case let .EnemyShrapnel(type, size):
            let typeName = type.name ?? ""
            return "EnemyShrapnel_type-(\(typeName))_size-\(size.name)"
        case let .Powerup(type):
            let typeName = type.name
            return "Powerup_type-(\(typeName))"
        case .NoPowerup:
            return "NoPowerup"
        case let .Bomber(numBombs):
            return "Bomber_numBombs-\(numBombs)"
        case let .Bomb(radius, time):
            return "Bomb_radius-\(radius)_time-\(time)"
        case .HourglassZone:
            return "HourglassZone"
        case .Mine:
            return "Mine"
        case .MineExplosion:
            return "MineExplosion"
        case let .Net(phase):
            return "Net_phase-\(phase)"
        case let .EnemyNet(size):
            let roundedSize = Int(round(size * 20))
            return "EnemyNet_size-\(roundedSize)"
        case let .Soldier(health):
            return "Soldier_health-\(health)"
        case let .PowerupTimer(percent):
            return "PowerupTimer_percent-\(percent)"

        case let .Drone(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "Drone_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .DroneRadar(upgrade):
            return "DroneRadar_upgrade-\(upgrade.name)"

        case let .LaserNode(upgrade, health):
            return "LaserNode_upgrade-\(upgrade.name)_health-\(health)"
        case let .LaserTurret(upgrade, isFiring):
            return "LaserTurret_upgrade-\(upgrade.name)_isFiring-\(isFiring)"
        case let .LaserRadar(upgrade, isSelected):
            return "LaserRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .ShotgunNode(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "ShotgunNode_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .ShotgunTurret(upgrade):
            return "ShotgunTurret_upgrade-\(upgrade.name)"
        case let .ShotgunRadar(upgrade, isSelected):
            return "ShotgunRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .Cannon(upgrade, health):
            return "Cannon_upgrade-\(upgrade.name)_health-\(health)"
        case let .CannonBox(upgrade):
            return "CannonBox_upgrade-\(upgrade.name)"
        case let .CannonTurret(upgrade):
            return "CannonTurret_upgrade-\(upgrade.name)"
        case let .CannonRadar(upgrade, isSelected):
            return "CannonRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .MissleSilo(upgrade, health):
            return "MissleSilo_upgrade-\(upgrade.name)_health-\(health)"
        case let .MissleSiloBox(upgrade):
            return "MissleSiloBox_upgrade-\(upgrade.name)"
        case let .MissleSiloRadar(upgrade, isSelected):
            return "MissleSiloRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"
        case .Missle:
            return "Missle"

        case .Cursor:
            return "Cursor"
        case let .Resource(amount, remaining):
            return "Resource_amount-\(amount)_remaining-\(remaining)"
        case let .ResourceLine(length):
            let roundedLength = Int(round(length * 20))
            return "ResourceLine_length-\(roundedLength)"
        case let .Shield(phase):
            return "Shield_phase-\(phase)"
        case let .ShieldSegment(health):
            return "ShieldSegment_health-\(health)"
        case let .Base(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "Base_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .BaseRadar(upgrade, isSelected):
            return "BaseRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"
        case let .BaseExplosion(index, total):
            return "BaseExplosion_index-\(index)_total-\(total)"
        case let .BaseSingleTurret(bulletUpgrade):
            return "BaseSingleTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .BaseRapidTurret(bulletUpgrade):
            return "BaseRapidTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .BaseDoubleTurret(bulletUpgrade):
            return "BaseDoubleTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .BaseBigTurret(bulletUpgrade):
            return "BaseBigTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .Bullet(upgrade, style):
            return "BaseTurretBullet_upgrade-\(upgrade.name)_style-\(style)"
        case .ColorPath:
            return nil
        case let .ColorLine(length, color):
            let roundedLength = Int(round(length * 20))
            return "ColorLine_length-\(roundedLength)_color-\(color)"
        case let .HueLine(length, hue):
            let roundedLength = Int(round(length * 20))
            return "HueLine_length-\(roundedLength)_hue-\(hue)"
        case let .ColorCircle(size, color):
            return "ColorCircle_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .ColorBox(size, color):
            return "ColorBox_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .HueBox(size, hue):
            return "HueBox_size\(Int(size.width))x\(Int(size.height))_hue-\(hue)"
        case let .FillColorCircle(size, color):
            return "FillColorCircle_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .FillColorBox(size, color):
            return "FillColorBox_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .FillHueBox(size, hue):
            return "FillHueBox_size\(Int(size.width))x\(Int(size.height))_hue-\(hue)"
        }
    }

    var atlasName: String? {
        switch self {
        // case .DroneRadar: return "Drone"
        default: return nil
        }
    }
}
