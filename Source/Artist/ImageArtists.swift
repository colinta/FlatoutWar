////
///  ImageArtists.swift
//

extension ImageIdentifier.EnemyType {
    func artist(health healthInt: Int) -> Artist {
        let artist: Artist
        let health = CGFloat(healthInt) / 100
        switch self {
        case .Soldier:
            artist = EnemySoldierArtist(health: health)
        case .SlowSoldier:
            artist = EnemySlowSoldierArtist(health: health)
        case .FastSoldier:
            artist = EnemyFastSoldierArtist(health: health)
        case .GiantSoldier:
            artist = EnemySoldierArtist(health: health)
            artist.size = CGSize(100)
        case .Leader:
            artist = EnemyLeaderArtist(health: health)
        case .Scout:
            artist = EnemyScoutArtist(health: health)
        case .Dozer:
            artist = EnemyDozerArtist(health: health)
        case .Jet:
            artist = EnemyJetArtist(health: health)
        case .BigJet:
            artist = EnemyBigJetArtist(health: health)
        case .JetTransport:
            artist = EnemyJetTransportArtist(health: health)
        case .Diamond:
            artist = EnemyDiamondArtist(health: health)
        }
        return artist
    }
}

extension ImageIdentifier.PowerupType {
    func artist() -> Artist {
        switch self {
            case .Mines:
                return MinesPowerupArtist()
            case .Grenade:
                return GrenadePowerupArtist()
            case .Bomber:
                return BomberPowerupArtist()
            case .Shield:
                return ShieldPowerupArtist()
            case .Soldiers:
                return SoldiersPowerupArtist()
            case .Hourglass:
                return HourglassPowerupArtist()
            case .Pulse:
                return PulsePowerupArtist()
            case .Laser:
                return LaserPowerupArtist()
            case .Net:
                return NetPowerupArtist()
            case .Coffee:
                return CoffeePowerupArtist()
        }
    }
}

extension ImageIdentifier.Size {

    var font: Font {
        switch self {
        case .Tiny: return TinyFont
        case .Small: return SmallFont
        case .Big, .Actual: return BigFont
        }
    }
}

extension ImageIdentifier {

    var artist: Artist {
        switch self {
        case .None:
            return Artist()
        case .Warning:
            return WarningArtist()
        case let .Dot(color):
            let artist = DotArtist()
            artist.color = UIColor(hex: color)
            return artist
        case .ResourceIcon:
            let color = UIColor(hex: ResourceBlue)
            let artist = CircleArtist(CGSize(10), color)
            artist.drawingMode = .fill
            return artist
        case .ExperienceIcon:
            let color = UIColor(hex: EnemySoldierGreen)
            let artist = RectArtist(CGSize(10), color)
            artist.drawingMode = .fill
            return artist
        case let .Box(colorInt):
            let color = UIColor(hex: colorInt)
            let artist = RectArtist(CGSize(10), color)
            artist.drawingMode = .fill
            return artist
        case let .WhiteLetter(letter, size):
            let artist = TextArtist()
            artist.font = size.font
            artist.text = letter

            return artist
        case let .Letter(letter, size, color):
            let artist = TextArtist()
            artist.font = size.font
            artist.text = letter
            artist.color = UIColor(hex: color)

            return artist
        case let .Button(style, color):
            let artist = ButtonArtist()
            artist.color = UIColor(hex: color)
            switch style {
            case .Square, .SquareSized, .RectSized:
                artist.style = .Square
                artist.size = style.size
            case .Circle, .CircleSized:
                artist.style = .Circle
                artist.size = style.size
            default:
                break
            }
            return artist
        case let .Enemy(enemyType, health):
            return enemyType.artist(health: health)
        case let .EnemyShrapnel(imageId, size):
            let artist = imageId.artist
            switch size {
            case .Tiny:
                artist.size *= 0.05
            case .Small:
                artist.size *= 0.1
            case .Big:
                artist.size *= 0.5
            case .Actual:
                break
            }
            return artist
        case let .Powerup(type):
            return type.artist()
        case .NoPowerup:
            return NoPowerupArtist()
        case let .Bomber(numBombs):
            return BomberArtist(numBombs: numBombs)
        case let .Bomb(radius, time):
            return BombArtist(maxRadius: CGFloat(radius), time: CGFloat(time) / 250)
        case .HourglassZone:
            let artist = HourglassZoneArtist()
            return artist
        case .Mine:
            let artist = MinesPowerupArtist()
            artist.size = CGSize(15)
            return artist
        case .MineExplosion:
            let artist = MineFragmentArtist()
            return artist
        case let .Net(phase):
            let artist = NetPowerupArtist()
            artist.fill = false
            artist.size = CGSize(100)
            artist.phase = CGFloat(phase) / 100
            return artist
        case let .EnemyNet(size):
            let artist = NetPowerupArtist()
            artist.fill = false
            artist.size = CGSize(size)
            return artist
        case let .Shield(phase):
            let artist = ShieldArtist()
            artist.phase = CGFloat(phase) / 100
            return artist
        case let .ShieldSegment(healthInt):
            let artist = ShieldSegmentArtist()
            artist.health = CGFloat(healthInt) / 100
            return artist
        case let .Soldier(healthInt):
            let artist = SoldierArtist(health: CGFloat(healthInt) / 100)
            return artist
        case let .PowerupTimer(percent):
            let artist = PowerupTimerArtist(percent: CGFloat(percent) / 100)
            return artist
        case let .Percent(percent, style):
            let artist = PercentArtist(style: style)
            artist.complete = CGFloat(percent) / 100
            return artist

        case let .Drone(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = DroneArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .DroneRadar(upgrade):
            let radius = upgrade.droneRadarRadius
            let artist = DroneRadarArtist(radius: radius)
            artist.color = upgrade.droneRadarColor
            artist.lineWidth = upgrade.droneRadarWidth
            return artist

        case let .LaserNode(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = LaserNodeArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .LaserTurret(upgrade, isFiring):
            let artist = LaserTurretArtist(hasUpgrade: upgrade.boolValue, isFiring: isFiring)
            return artist
        case let .LaserRadar(upgrade, isSelected):
            let width = upgrade.laserRadarRadius
            let height = upgrade.laserSweepWidth
            let artist = LaserRadarArtist(
                size: CGSize(width, height),
                color: UIColor(hex: upgrade.laserRadarColor),
                isSelected: isSelected
                )
            return artist

        case let .ShotgunNode(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = ShotgunArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .ShotgunTurret(upgrade):
            return ShotgunTurretArtist(hasUpgrade: upgrade.boolValue)
        case let .ShotgunRadar(upgrade, isSelected):
           let artist = ShotgunRadarArtist(
               radius: upgrade.shotgunRadarRadius,
               sweepAngle: upgrade.shotgunSweepAngle,
               color: UIColor(hex: upgrade.shotgunRadarColor),
               isSelected: isSelected
           )
           return artist

        case let .Cannon(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = CannonArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .CannonBox(upgrade):
            let artist = CannonBoxArtist(
                CGSize(width: upgrade.boolValue ? 12 : 10, height: 20),
                UIColor(hex: CannonTurretFillColor)
                )
            artist.strokeColor = UIColor(hex: CannonTurretStrokeColor)
            artist.shadowColor = UIColor(hex: CannonTurretFillColor)
            artist.shadowed = .True
            return artist
        case let .CannonTurret(upgrade):
            let artist = RectArtist(
                CGSize(width: 10, height: upgrade.boolValue ? 5 : 4),
                UIColor(hex: CannonTurretFillColor)
                )
            artist.strokeColor = UIColor(hex: CannonTurretStrokeColor)
            return artist
        case let .CannonRadar(upgrade, isSelected):
            let artist = CannonRadarArtist(
                minRadius: upgrade.cannonMinRadarRadius,
                maxRadius: upgrade.cannonMaxRadarRadius,
                sweepAngle: upgrade.cannonSweepAngle,
                color: UIColor(hex: upgrade.cannonRadarColor),
                isSelected: isSelected
                )
            return artist

        case let .MissleSilo(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = MissleSiloArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .MissleSiloBox(upgrade):
            let artist = MissleSiloBoxArtist(
                CGSize(width: upgrade.boolValue ? 12 : 10, height: 20),
                UIColor(hex: MissleSiloFillColor)
                )
            artist.strokeColor = UIColor(hex: MissleSiloStrokeColor)
            artist.shadowColor = UIColor(hex: MissleSiloFillColor)
            artist.shadowed = .True
            return artist
        case let .MissleSiloRadar(upgrade, isSelected):
            let artist = MissleRadarArtist(
                radius: upgrade.missleSiloRadarRadius,
                color: UIColor(hex: upgrade.missleSiloRadarColor),
                isSelected: isSelected
                )
            return artist
        case .Missle:
            let artist = MissleArtist()
            return artist

        case let .Resource(amount, remaining):
            let artist = ResourceArtist(amount: CGFloat(amount), remaining: CGFloat(remaining) / CGFloat(amount))
            return artist
        case let .ResourceLine(length):
            let color = UIColor(hex: ResourceBlue)
            let artist = LineArtist(length, color)
            artist.lineWidth = 2
            return artist
        case .Cursor:
            let artist = CursorArtist()
            return artist
        case let .Base(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = BaseArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .BaseRadar(upgrade, isSelected):
            let artist = BaseRadarArtist(
                radius: upgrade.baseRadarRadius,
                sweepAngle: upgrade.baseSweepAngle,
                color: UIColor(hex: upgrade.baseRadarColor),
                isSelected: isSelected
                )
            return artist
        case let .BaseExplosion(index, total):
            let spread = TAU / CGFloat(total)
            let angle = -spread * CGFloat(index)
            let artist = BaseExplosionArtist(angle: angle, spread: spread)
            return artist
        case let .BaseSingleTurret(bulletUpgrade):
            let artist = BaseTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .BaseRapidTurret(bulletUpgrade):
            let artist = BaseRapidTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .BaseDoubleTurret(bulletUpgrade):
            let artist = BaseDoubleTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .BaseBigTurret(bulletUpgrade):
            let artist = BaseBigTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .Bullet(upgrade, style):
            let artist = BulletArtist(upgrade: upgrade, style: style)
            return artist
        case let .ColorLine(length, color):
            let color = UIColor(hex: color)
            let artist = LineArtist(length, color)
            return artist
        case let .ColorPath(path, color):
            let color = UIColor(hex: color)
            let artist = PathArtist(path, color)
            return artist
        case let .HueLine(length, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = LineArtist(length, color)
            return artist
        case let .ColorCircle(size, color):
            let color = UIColor(hex: color)
            let artist = CircleArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .ColorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .HueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .FillColorCircle(size, color):
            let color = UIColor(hex: color)
            let artist = CircleArtist(size, color)
            artist.drawingMode = .fill
            return artist
        case let .FillColorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            artist.drawingMode = .fill
            return artist
        case let .FillHueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            artist.drawingMode = .fill
            return artist
        }
    }

}
