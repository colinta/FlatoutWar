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
    case enemyBoat

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

    case guardNode(movementUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, health: Int)
    case guardTurret(upgrade: HasUpgrade)
    case guardRadar(upgrade: HasUpgrade, isSelected: Bool)

    case cannon(upgrade: HasUpgrade, health: Int)
    case cannonBox(upgrade: HasUpgrade)
    case cannonTurret(upgrade: HasUpgrade)
    case cannonRadar(upgrade: HasUpgrade, isSelected: Bool)

    case missleSilo(upgrade: HasUpgrade, health: Int)
    case missleSiloBox(upgrade: HasUpgrade)
    case missleSiloRadar(upgrade: HasUpgrade, isSelected: Bool)
    case missle

    case crosshairs(upgrade: HasUpgrade)
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
            return "dot:color-\(color)"
        case .experienceIcon:
            return "experienceIcon"
        case let .box(color):
            return "box:color-\(color)"
        case let .percent(percent, style):
            return "percent:percent-\(percent):style-\(style)"
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
            return "whiteLetter:letter-\(nameLetter):size-\(size.name)"
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
            return "letter:\(nameLetter):size-\(size.name):color-\(color)"
        case let .button(style, color):
            return "button:style-\(style.name):color-\(color)"

        case let .enemy(type, health):
            let typeName = type.name
            return "enemy:type-(\(typeName)):health-\(health)"
        case let .enemyShrapnel(type, size):
            let typeName = type.name ?? ""
            return "enemyShrapnel:type-(\(typeName)):size-\(size.name)"
        case .enemyBoat:
            return "enemyBoat"
        case let .woodsBossFoot(health):
            return "woodsBossFoot:health-\(health)"
        case let .woodsBossBody(health):
            return "woodsBossBody:health-\(health)"

        case let .powerup(type):
            let typeName = type.name
            return "powerup:type-(\(typeName))"
        case .noPowerup:
            return "noPowerup"
        case let .bomber(numBombs):
            return "bomber:numBombs-\(numBombs)"
        case let .bomb(radius, time):
            return "bomb:radius-\(radius):time-\(time)"
        case .hourglassZone:
            return "hourglassZone"
        case .mine:
            return "mine"
        case .mineExplosion:
            return "mineExplosion"
        case let .net(phase):
            return "net:phase-\(phase)"
        case let .enemyNet(size):
            let roundedSize = Int(round(size * 20))
            return "enemyNet:size-\(roundedSize)"
        case let .soldier(health):
            return "soldier:health-\(health)"
        case let .powerupTimer(percent):
            return "powerupTimer:percent-\(percent)"

        case let .drone(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "drone:movementUpgrade-\(movementUpgrade.name):bulletUpgrade-\(bulletUpgrade.name):radarUpgrade-\(radarUpgrade.name):health-\(health)"
        case let .droneRadar(upgrade):
            return "droneRadar:upgrade-\(upgrade.name)"

        case let .laserNode(upgrade, health):
            return "laserNode:upgrade-\(upgrade.name):health-\(health)"
        case let .laserTurret(upgrade, isFiring):
            return "laserTurret:upgrade-\(upgrade.name):isFiring-\(isFiring)"
        case let .laserRadar(upgrade, isSelected):
            return "laserRadar:upgrade-\(upgrade.name):isSelected-\(isSelected)"

        case let .guardNode(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "GuardNode:movementUpgrade-\(movementUpgrade.name):bulletUpgrade-\(bulletUpgrade.name):radarUpgrade-\(radarUpgrade.name):health-\(health)"
        case let .guardTurret(upgrade):
            return "GuardTurret:upgrade-\(upgrade.name)"
        case let .guardRadar(upgrade, isSelected):
            return "GuardRadar:upgrade-\(upgrade.name):isSelected-\(isSelected)"

        case let .cannon(upgrade, health):
            return "cannon:upgrade-\(upgrade.name):health-\(health)"
        case let .cannonBox(upgrade):
            return "cannonBox:upgrade-\(upgrade.name)"
        case let .cannonTurret(upgrade):
            return "cannonTurret:upgrade-\(upgrade.name)"
        case let .cannonRadar(upgrade, isSelected):
            return "cannonRadar:upgrade-\(upgrade.name):isSelected-\(isSelected)"

        case let .missleSilo(upgrade, health):
            return "missleSilo:upgrade-\(upgrade.name):health-\(health)"
        case let .missleSiloBox(upgrade):
            return "missleSiloBox:upgrade-\(upgrade.name)"
        case let .missleSiloRadar(upgrade, isSelected):
            return "missleSiloRadar:upgrade-\(upgrade.name):isSelected-\(isSelected)"
        case .missle:
            return "missle"

        case let .crosshairs(upgrade):
            return "crosshairs:upgrade-\(upgrade)"
        case .cursor:
            return "cursor"
        case let .shield(phase):
            return "shield:phase-\(phase)"
        case let .shieldSegment(health):
            return "shieldSegment:health-\(health)"
        case let .base(movementUpgrade, bulletUpgrade, radarUpgrade, health):
            return "base:movementUpgrade-\(movementUpgrade.name):bulletUpgrade-\(bulletUpgrade.name):radarUpgrade-\(radarUpgrade.name):health-\(health)"
        case let .baseRadar(upgrade, isSelected):
            return "baseRadar:upgrade-\(upgrade.name):isSelected-\(isSelected)"
        case let .baseExplosion(index, total):
            return "baseExplosion:index-\(index):total-\(total)"
        case let .baseSingleTurret(bulletUpgrade):
            return "baseSingleTurret:bulletUpgrade-\(bulletUpgrade.name)"
        case let .baseDoubleTurret(bulletUpgrade):
            return "baseDoubleTurret:bulletUpgrade-\(bulletUpgrade.name)"
        case let .baseBigTurret(bulletUpgrade):
            return "baseBigTurret:bulletUpgrade-\(bulletUpgrade.name)"
        case let .bullet(upgrade, style):
            return "BaseTurretBullet:upgrade-\(upgrade.name):style-\(style)"
        case .colorPath:
            return nil
        case let .colorLine(length, color):
            let roundedLength = Int(round(length * 20))
            return "colorLine:length-\(roundedLength):color-\(color)"
        case let .hueLine(length, hue):
            let roundedLength = Int(round(length * 20))
            return "hueLine:length-\(roundedLength):hue-\(hue)"
        case let .colorCircle(size, color):
            return "colorCircle:size\(Int(size.width))x\(Int(size.height)):color-\(color)"
        case let .colorBox(size, color):
            return "colorBox:size\(Int(size.width))x\(Int(size.height)):color-\(color)"
        case let .hueBox(size, hue):
            return "hueBox:size\(Int(size.width))x\(Int(size.height)):hue-\(hue)"
        case let .fillColorCircle(size, color):
            return "fillColorCircle:size\(Int(size.width))x\(Int(size.height)):color-\(color)"
        case let .fillColorBox(size, color):
            return "fillColorBox:size\(Int(size.width))x\(Int(size.height)):color-\(color)"
        case let .fillHueBox(size, hue):
            return "fillHueBox:size\(Int(size.width))x\(Int(size.height)):hue-\(hue)"
        }
    }

    var atlasName: String? {
        switch self {
        default: return nil
        }
    }
}
