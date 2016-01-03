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

extension ImageIdentifier.LetterSize {

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
        case let .Letter(letter, size):
            let artist = TextArtist()
            artist.text = letter
            artist.font = size.font

            return artist
        case let .Button(style):
            let artist = ButtonArtist()
            switch style {
            case .Square:
                artist.style = .Square
                artist.size = CGSize(50)
            case .Circle:
                artist.style = .Circle
                artist.size = CGSize(24)
            default:
                break
            }
            return artist
        case let .Enemy(enemyType, health):
            return enemyType.artist(health: health)
        case let .EnemyShrapnel(enemyType):
            let artist = enemyType.artist(health: 1)
            artist.size = artist.size * 0.1
            return artist
        case .Cursor:
            let artist = CursorArtist()
            return artist
        case let .Percent(percent):
            let artist = PercentArtist()
            artist.complete = CGFloat(percent) / 100
            return artist
        case let .Drone(upgrade):
            let artist = DroneArtist(upgrade: upgrade)
            return artist
        case let .Radar(upgrade):
            let artist = RadarArtist(upgrade: upgrade)
            return artist
        case let .Base(upgrade, healthInt):
            let artist = BaseArtist(upgrade: upgrade)
            artist.health = CGFloat(healthInt) / 100
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
        case let .HueLine(length, hue):
            let color = UIColor(hue: CGFloat(hue) / 255, saturation: 1, brightness: 1, alpha: 1)
            let artist = LineArtist(length, color)
            return artist
        default:
            return Artist()
        }
    }

}
