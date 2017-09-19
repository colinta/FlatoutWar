////
///  ImageArtists.swift
//

extension ImageIdentifier.EnemyType {
    func artist(health healthInt: Int) -> Artist {
        let artist: Artist
        let health = CGFloat(healthInt) / 100
        switch self {
        case .soldier:
            artist = EnemySoldierArtist(health: health)
        case .slowSoldier:
            artist = EnemySlowSoldierArtist(health: health)
        case .fastSoldier:
            artist = EnemyFastSoldierArtist(health: health)
        case .giantSoldier:
            artist = EnemySoldierArtist(health: health)
            artist.size = CGSize(100)
        case .leader:
            artist = EnemyLeaderArtist(health: health)
        case .scout:
            artist = EnemyScoutArtist(health: health)
        case .dozer:
            artist = EnemyDozerArtist(health: health)
        case .jet:
            artist = EnemyJetArtist(health: health)
        case .bigJet:
            artist = EnemyBigJetArtist(health: health)
        case .jetTransport:
            artist = EnemyJetTransportArtist(health: health)
        case .diamond:
            artist = EnemyDiamondArtist(health: health)
        }
        return artist
    }
}

extension ImageIdentifier.PowerupType {
    func artist() -> Artist {
        switch self {
            case .mines:
                return MinesPowerupArtist()
            case .grenade:
                return GrenadePowerupArtist()
            case .bomber:
                return BomberPowerupArtist()
            case .shield:
                return ShieldPowerupArtist()
            case .soldiers:
                return SoldiersPowerupArtist()
            case .hourglass:
                return HourglassPowerupArtist()
            case .pulse:
                return PulsePowerupArtist()
            case .laser:
                return LaserPowerupArtist()
            case .net:
                return NetPowerupArtist()
            case .coffee:
                return CoffeePowerupArtist()
        }
    }
}

extension ImageIdentifier.Size {

    var font: Font {
        switch self {
        case .tiny: return TinyFont
        case .small: return SmallFont
        case .big, .actual: return BigFont
        }
    }
}

extension ImageIdentifier {

    var artist: Artist {
        switch self {
        case .none:
            return Artist()
        case .warning:
            return WarningArtist()
        case let .dot(color):
            let artist = DotArtist()
            artist.color = UIColor(hex: color)
            return artist
        case .experienceIcon:
            let color = UIColor(hex: EnemySoldierGreen)
            let artist = RectArtist(CGSize(10), color)
            artist.drawingMode = .fill
            return artist
        case let .box(colorInt):
            let color = UIColor(hex: colorInt)
            let artist = RectArtist(CGSize(10), color)
            artist.drawingMode = .fill
            return artist
        case let .whiteLetter(letter, size):
            let artist = TextArtist()
            artist.font = size.font
            artist.text = letter

            return artist
        case let .letter(letter, size, color):
            let artist = TextArtist()
            artist.font = size.font
            artist.text = letter
            artist.color = UIColor(hex: color)

            return artist
        case let .button(style, color):
            let artist = ButtonArtist()
            artist.color = UIColor(hex: color)
            switch style {
            case .square, .squareSized, .rectSized:
                artist.style = .square
                artist.size = style.size
            case .circle, .circleSized:
                artist.style = .circle
                artist.size = style.size
            default:
                break
            }
            return artist
        case let .woodsBossFoot(healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = WoodsBossFootArtist(health: health)
            return artist
        case let .woodsBossBody(healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = WoodsBossBodyArtist(health: health)
            return artist
        case let .enemy(enemyType, health):
            return enemyType.artist(health: health)
        case let .enemyShrapnel(imageId, size):
            let artist = imageId.artist
            switch size {
            case .tiny:
                artist.size *= 0.05
            case .small:
                artist.size *= 0.1
            case .big:
                artist.size *= 0.5
            case .actual:
                break
            }
            return artist
        case .enemyBoat:
            return EnemyBoatArtist()
        case let .powerup(type):
            return type.artist()
        case .noPowerup:
            return NoPowerupArtist()
        case let .bomber(numBombs):
            return BomberArtist(numBombs: numBombs)
        case let .bomb(radius, time):
            return BombArtist(maxRadius: CGFloat(radius), time: CGFloat(time) / 250)
        case .hourglassZone:
            let artist = HourglassZoneArtist()
            return artist
        case .mine:
            let artist = MinesPowerupArtist()
            artist.size = CGSize(15)
            return artist
        case .mineExplosion:
            let artist = MineFragmentArtist()
            return artist
        case let .net(phase):
            let artist = NetPowerupArtist()
            artist.fill = false
            artist.size = CGSize(100)
            artist.phase = CGFloat(phase) / 100
            return artist
        case let .enemyNet(size):
            let artist = NetPowerupArtist()
            artist.fill = false
            artist.size = CGSize(size)
            return artist
        case let .shield(phase):
            let artist = ShieldArtist()
            artist.phase = CGFloat(phase) / 100
            return artist
        case let .shieldSegment(healthInt):
            let artist = ShieldSegmentArtist()
            artist.health = CGFloat(healthInt) / 100
            return artist
        case let .soldier(healthInt):
            let artist = SoldierArtist(health: CGFloat(healthInt) / 100)
            return artist
        case let .powerupTimer(percent):
            let artist = PowerupTimerArtist(percent: CGFloat(percent) / 100)
            return artist
        case let .percent(percent, style):
            let artist = PercentArtist(style: style)
            artist.complete = CGFloat(percent) / 100
            return artist

        case let .drone(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = DroneArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .droneRadar(upgrade):
            let radius = upgrade.droneRadarRadius
            let artist = DroneRadarArtist(radius: radius)
            artist.color = upgrade.droneRadarColor
            artist.lineWidth = upgrade.droneRadarWidth
            return artist

        case let .laserNode(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = LaserNodeArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .laserTurret(upgrade, isFiring):
            let artist = LaserTurretArtist(hasUpgrade: upgrade.boolValue, isFiring: isFiring)
            return artist
        case let .laserRadar(upgrade, isSelected):
            let width = upgrade.laserRadarRadius
            let height = upgrade.laserSweepWidth
            let artist = LaserRadarArtist(
                hasUpgrade: upgrade.boolValue,
                size: CGSize(width, height),
                color: UIColor(hex: upgrade.laserRadarColor),
                isSelected: isSelected
                )
            return artist

        case let .guardNode(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = GuardArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .guardTurret(upgrade):
            return GuardTurretArtist(hasUpgrade: upgrade.boolValue)
        case let .guardRadar(upgrade, isSelected):
           let artist = GuardRadarArtist(
                hasUpgrade: upgrade.boolValue,
               radius: upgrade.shotgunRadarRadius,
               sweepAngle: upgrade.shotgunSweepAngle,
               color: UIColor(hex: upgrade.shotgunRadarColor),
               isSelected: isSelected
           )
           return artist

        case let .cannon(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = CannonArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .cannonBox(upgrade):
            let artist = CannonBoxArtist(
                CGSize(width: upgrade.boolValue ? 12 : 10, height: 20),
                UIColor(hex: CannonTurretFillColor)
                )
            artist.strokeColor = UIColor(hex: CannonTurretStrokeColor)
            artist.shadowColor = UIColor(hex: CannonTurretFillColor)
            artist.shadowed = .true
            return artist
        case let .cannonTurret(upgrade):
            let artist = RectArtist(
                CGSize(width: 10, height: upgrade.boolValue ? 5 : 4),
                UIColor(hex: CannonTurretFillColor)
                )
            artist.strokeColor = UIColor(hex: CannonTurretStrokeColor)
            return artist
        case let .cannonRadar(upgrade, isSelected):
            let artist = CannonRadarArtist(
                hasUpgrade: upgrade.boolValue,
                minRadius: upgrade.cannonMinRadarRadius,
                maxRadius: upgrade.cannonMaxRadarRadius,
                sweepAngle: upgrade.cannonSweepAngle,
                color: UIColor(hex: upgrade.cannonRadarColor),
                isSelected: isSelected
                )
            return artist

        case let .missleSilo(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = MissleSiloArtist(hasUpgrade: upgrade.boolValue, health: health)
            return artist
        case let .missleSiloBox(upgrade):
            let artist = MissleSiloBoxArtist(
                CGSize(width: upgrade.boolValue ? 12 : 10, height: 20),
                UIColor(hex: MissleSiloFillColor)
                )
            artist.strokeColor = UIColor(hex: MissleSiloStrokeColor)
            artist.shadowColor = UIColor(hex: MissleSiloFillColor)
            artist.shadowed = .true
            return artist
        case let .missleSiloRadar(upgrade, isSelected):
            let artist = MissleRadarArtist(
                hasUpgrade: upgrade.boolValue,
                radius: upgrade.missleSiloRadarRadius,
                color: UIColor(hex: upgrade.missleSiloRadarColor),
                isSelected: isSelected
                )
            return artist
        case .missle:
            let artist = MissleArtist()
            return artist

        case .cursor:
            let artist = CursorArtist()
            return artist
        case let .base(movementUpgrade, bulletUpgrade, radarUpgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = BaseArtist(movementUpgrade, bulletUpgrade, radarUpgrade, health: health)
            return artist
        case let .baseRadar(upgrade, isSelected):
            let artist = BaseRadarArtist(
                hasUpgrade: upgrade.boolValue,
                radius: upgrade.baseRadarRadius,
                sweepAngle: upgrade.baseSweepAngle,
                color: UIColor(hex: upgrade.baseRadarColor),
                isSelected: isSelected
                )
            return artist
        case let .baseExplosion(index, total):
            let spread = TAU / CGFloat(total)
            let angle = -spread * CGFloat(index)
            let artist = BaseExplosionArtist(angle: angle, spread: spread)
            return artist
        case let .baseSingleTurret(bulletUpgrade):
            let artist = BaseTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .baseDoubleTurret(bulletUpgrade):
            let artist = BaseDoubleTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .baseBigTurret(bulletUpgrade):
            let artist = BaseBigTurretArtist(bulletUpgrade: bulletUpgrade)
            return artist
        case let .bullet(upgrade, style):
            let artist = BulletArtist(upgrade: upgrade, style: style)
            return artist
        case let .colorLine(length, color):
            let color = UIColor(hex: color)
            let artist = LineArtist(length, color)
            return artist
        case let .colorPath(path, color):
            let color = UIColor(hex: color)
            let artist = PathArtist(path, color)
            return artist
        case let .hueLine(length, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = LineArtist(length, color)
            return artist
        case let .colorCircle(size, color):
            let color = UIColor(hex: color)
            let artist = CircleArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .colorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .hueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            artist.drawingMode = .stroke
            return artist
        case let .fillColorCircle(size, color):
            let color = UIColor(hex: color)
            let artist = CircleArtist(size, color)
            artist.drawingMode = .fill
            return artist
        case let .fillColorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            artist.drawingMode = .fill
            return artist
        case let .fillHueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            artist.drawingMode = .fill
            return artist
        }
    }

}
