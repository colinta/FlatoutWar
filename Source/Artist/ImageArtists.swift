//
//  ImageArtists.swift
//  PlayWithSprites
//
//  Created by Colin Gray on 12/19/15.
//  Copyright © 2015 colinta. All rights reserved.
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
        case .GiantSoldier:
            artist = EnemySoldierArtist(health: health)
            artist.size *= 10
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
        }
        return artist
    }
}

extension ImageIdentifier.PowerupType {
    func artist() -> Artist {
        switch self {
            case .Decoy:
                return DecoyPowerupArtist()
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
        case .Small: return SmallFont
        case .Big: return BigFont
        }
    }
}

extension ImageIdentifier {

    var artist: Artist {
        switch self {
        case .None:
            return Artist()
        case let .WhiteLetter(letter, size):
            let artist = TextArtist()
            artist.text = letter
            artist.font = size.font

            return artist
        case let .Letter(letter, size, color):
            let artist = TextArtist()
            artist.text = letter
            artist.font = size.font
            artist.color = UIColor(hex: color)

            return artist
        case let .Button(style):
            let artist = ButtonArtist()
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
        case let .EnemyShrapnel(enemyType, size):
            let artist = enemyType.artist(health: 100)
            switch size {
            case .Small:
                artist.size = artist.size * 0.1
            case .Big:
                artist.size = artist.size * 0.5
            }
            return artist
        case let .Powerup(type):
            return type.artist()
        case .NoPowerup:
            return NoPowerupArtist()
        case let .Bomber(numBombs):
            return BomberArtist(numBombs: numBombs)
        case let .Bomb(radius, time):
            return BombArtist(maxRadius: CGFloat(radius), time: CGFloat(time) / 100)
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
        case let .Percent(percent, style):
            let artist = PercentArtist(style: style)
            artist.complete = CGFloat(percent) / 100
            return artist
        case let .Drone(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = DroneArtist(upgrade: upgrade, health: health)
            return artist
        case .Cursor:
            let artist = CursorArtist()
            return artist
        case let .Base(upgrade, healthInt):
            let health = CGFloat(healthInt) / 100
            let artist = BaseArtist(upgrade: upgrade, health: health)
            return artist
        case let .BaseRadar(upgrade):
            let artist = RadarArtist(upgrade: upgrade)
            return artist
        case let .BaseExplosion(index, total):
            let spread = TAU / CGFloat(total)
            let angle = -spread * CGFloat(index)
            let artist = BaseExplosionArtist(angle: angle, spread: spread)
            return artist
        case let .BaseSingleTurret(upgrade):
            let artist = BaseTurretArtist(upgrade: upgrade)
            return artist
        case let .BaseDoubleTurret(upgrade):
            let artist = BaseDoubleTurretArtist(upgrade: upgrade)
            return artist
        case let .BaseBigTurret(upgrade):
            let artist = BaseBigTurretArtist(upgrade: upgrade)
            return artist
        case let .BaseTurretBullet(upgrade):
            let artist = BaseTurretBulletArtist(upgrade: upgrade)
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
        case let .ColorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            return artist
        case let .HueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            return artist
        case let .FillColorBox(size, color):
            let color = UIColor(hex: color)
            let artist = RectArtist(size, color)
            artist.drawingMode = .Fill
            return artist
        case let .FillHueBox(size, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = RectArtist(size, color)
            artist.drawingMode = .Fill
            return artist
        }
    }

}
