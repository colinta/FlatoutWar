////
///  ImageIdentifier.swift
//

indirect enum ImageIdentifier {
    enum Size {
        case tiny
        case small
        case big
        case actual

        var name: String { return "\(self)" }
    }

    enum EnemyType {
        case soldier
        case slowSoldier
        case fastSoldier
        case leader
        case scout
        case dozer
        case giantSoldier

        case jet
        case bigJet
        case jetTransport

        case diamond

        var name: String { return "\(self)" }
    }

    enum PowerupType {
        case mines
        case grenade
        case bomber
        case shield
        case soldiers
        case hourglass
        case pulse
        case laser
        case net
        case coffee

        var name: String { return "\(self)" }
    }

    case none
    case dot(color: Int)
    case experienceIcon
    case box(color: Int)
    case warning
    case whiteLetter(String, size: Size)
    case letter(String, size: Size, color: Int)
    case button(style: ButtonStyle, color: Int)
    case percent(Int, style: PercentStyle)

    case enemy(EnemyType, health: Int)
    case enemyShrapnel(ImageIdentifier, size: Size)

    case woodsBossFoot(health: Int)
    case woodsBossBody(health: Int)

    case powerup(type: PowerupType)
    case noPowerup
    case bomber(numBombs: Int)
    case bomb(radius: Int, time: Int)
    case hourglassZone
    case mine
    case mineExplosion
    case net(phase: Int)
    case enemyNet(size: CGFloat)
    case shield(phase: Int)
    case shieldSegment(health: Int)
    case soldier(health: Int)
    case powerupTimer(percent: Int)

    case drone(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case droneRadar(upgrade: HasUpgrade)

    case laserNode(upgrade: HasUpgrade, health: Int)
    case laserTurret(upgrade: HasUpgrade, isFiring: Bool)
    case laserRadar(upgrade: HasUpgrade, isSelected: Bool)

    case shotgunNode(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case shotgunTurret(upgrade: HasUpgrade)
    case shotgunRadar(upgrade: HasUpgrade, isSelected: Bool)

    case cannon(upgrade: HasUpgrade, health: Int)
    case cannonBox(upgrade: HasUpgrade)
    case cannonTurret(upgrade: HasUpgrade)
    case cannonRadar(upgrade: HasUpgrade, isSelected: Bool)

    case missleSilo(upgrade: HasUpgrade, health: Int)
    case missleSiloBox(upgrade: HasUpgrade)
    case missleSiloRadar(upgrade: HasUpgrade, isSelected: Bool)
    case missle

    case cursor
    case base(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case baseRadar(upgrade: HasUpgrade, isSelected: Bool)
    case baseExplosion(index: Int, total: Int)

    case baseSingleTurret(bulletUpgrade: HasUpgrade)
    case baseDoubleTurret(bulletUpgrade: HasUpgrade)
    case baseBigTurret(bulletUpgrade: HasUpgrade)
    case bullet(upgrade: HasUpgrade, style: BulletNode.Style)

    case colorPath(path: UIBezierPath, color: Int)
    case colorLine(length: CGFloat, color: Int)
    case hueLine(length: CGFloat, hue: Int)
    case colorCircle(size: CGSize, color: Int)
    case colorBox(size: CGSize, color: Int)
    case hueBox(size: CGSize, hue: Int)
    case fillColorCircle(size: CGSize, color: Int)
    case fillColorBox(size: CGSize, color: Int)
    case fillHueBox(size: CGSize, hue: Int)

    var name: String? {
        switch self {
        case .none:
            return "none"
        case .warning:
            return "warning"
        case let .dot(color):
            return "dot_color-\(color)"
        case .experienceIcon:
            return "experienceIcon"
        case let .box(color):
            return "box_color-\(color)"
        case let .percent(percent, style):
            return "percent_percent-\(percent)_style-\(style)"
        case let .whiteLetter(letter, size):
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
            return "whiteLetter_letter-\(nameLetter)_size-\(size.name)"
        case let .letter(letter, size, color):
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
            return "letter_\(nameLetter)_size-\(size.name)_color-\(color)"
        case let .button(style, color):
            return "button_style-\(style.name)_color-\(color)"

        case let .enemy(type, health):
            let typeName = type.name
            return "enemy_type-(\(typeName))_health-\(health)"
        case let .enemyShrapnel(type, size):
            let typeName = type.name ?? ""
            return "enemyShrapnel_type-(\(typeName))_size-\(size.name)"
        case let .woodsBossFoot(health):
            return "woodsBossFoot_health-\(health)"
        case let .woodsBossBody(health):
            return "woodsBossBody_health-\(health)"

        case let .powerup(type):
            let typeName = type.name
            return "powerup_type-(\(typeName))"
        case .noPowerup:
            return "noPowerup"
        case let .bomber(numBombs):
            return "bomber_numBombs-\(numBombs)"
        case let .bomb(radius, time):
            return "bomb_radius-\(radius)_time-\(time)"
        case .hourglassZone:
            return "hourglassZone"
        case .mine:
            return "mine"
        case .mineExplosion:
            return "mineExplosion"
        case let .net(phase):
            return "net_phase-\(phase)"
        case let .enemyNet(size):
            let roundedSize = Int(round(size * 20))
            return "enemyNet_size-\(roundedSize)"
        case let .soldier(health):
            return "soldier_health-\(health)"
        case let .powerupTimer(percent):
            return "powerupTimer_percent-\(percent)"

        case let .drone(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "drone_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .droneRadar(upgrade):
            return "droneRadar_upgrade-\(upgrade.name)"

        case let .laserNode(upgrade, health):
            return "laserNode_upgrade-\(upgrade.name)_health-\(health)"
        case let .laserTurret(upgrade, isFiring):
            return "laserTurret_upgrade-\(upgrade.name)_isFiring-\(isFiring)"
        case let .laserRadar(upgrade, isSelected):
            return "laserRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .shotgunNode(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "shotgunNode_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .shotgunTurret(upgrade):
            return "shotgunTurret_upgrade-\(upgrade.name)"
        case let .shotgunRadar(upgrade, isSelected):
            return "shotgunRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .cannon(upgrade, health):
            return "cannon_upgrade-\(upgrade.name)_health-\(health)"
        case let .cannonBox(upgrade):
            return "cannonBox_upgrade-\(upgrade.name)"
        case let .cannonTurret(upgrade):
            return "cannonTurret_upgrade-\(upgrade.name)"
        case let .cannonRadar(upgrade, isSelected):
            return "cannonRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"

        case let .missleSilo(upgrade, health):
            return "missleSilo_upgrade-\(upgrade.name)_health-\(health)"
        case let .missleSiloBox(upgrade):
            return "missleSiloBox_upgrade-\(upgrade.name)"
        case let .missleSiloRadar(upgrade, isSelected):
            return "missleSiloRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"
        case .missle:
            return "missle"

        case .cursor:
            return "cursor"
        case let .shield(phase):
            return "shield_phase-\(phase)"
        case let .shieldSegment(health):
            return "shieldSegment_health-\(health)"
        case let .base(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "base_movementUpgrade-\(movementUpgrade.name)_bulletUpgrade-\(bulletUpgrade.name)_radarUpgrade-\(radarUpgrade.name)_health-\(health)"
        case let .baseRadar(upgrade, isSelected):
            return "baseRadar_upgrade-\(upgrade.name)_isSelected-\(isSelected)"
        case let .baseExplosion(index, total):
            return "baseExplosion_index-\(index)_total-\(total)"
        case let .baseSingleTurret(bulletUpgrade):
            return "baseSingleTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .baseDoubleTurret(bulletUpgrade):
            return "baseDoubleTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .baseBigTurret(bulletUpgrade):
            return "baseBigTurret_bulletUpgrade-\(bulletUpgrade.name)"
        case let .bullet(upgrade, style):
            return "BaseTurretBullet_upgrade-\(upgrade.name)_style-\(style)"
        case .colorPath:
            return nil
        case let .colorLine(length, color):
            let roundedLength = Int(round(length * 20))
            return "colorLine_length-\(roundedLength)_color-\(color)"
        case let .hueLine(length, hue):
            let roundedLength = Int(round(length * 20))
            return "hueLine_length-\(roundedLength)_hue-\(hue)"
        case let .colorCircle(size, color):
            return "colorCircle_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .colorBox(size, color):
            return "colorBox_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .hueBox(size, hue):
            return "hueBox_size\(Int(size.width))x\(Int(size.height))_hue-\(hue)"
        case let .fillColorCircle(size, color):
            return "fillColorCircle_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .fillColorBox(size, color):
            return "fillColorBox_size\(Int(size.width))x\(Int(size.height))_color-\(color)"
        case let .fillHueBox(size, hue):
            return "fillHueBox_size\(Int(size.width))x\(Int(size.height))_hue-\(hue)"
        }
    }

    var atlasName: String? {
        switch self {
        // case .DroneRadar: return "Drone"
        default: return nil
        }
    }
}
