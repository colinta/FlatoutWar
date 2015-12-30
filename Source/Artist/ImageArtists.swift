//
//  ImageArtists.swift
//  PlayWithSprites
//
//  Created by Colin Gray on 12/19/15.
//  Copyright © 2015 colinta. All rights reserved.
//

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
        case let .Button(type, touched):
            let artist = ButtonArtist()
            artist.touched = touched
            switch type {
            case .Circle:
                artist.style = .Circle
                artist.size = CGSize(width: 24, height: 24)
            case .Play:
                artist.text = "START"
                artist.style = .Octagon
            case .Setup:
                artist.text = "SETUP"
                artist.style = .Octagon
            case .Pause:
                artist.text = "||"
                artist.style = .None
            case .Resume:
                artist.text = "RESUME"
                artist.style = .Square
            case .Restart:
                artist.text = "RESTART"
                artist.style = .Square
            case .Quit:
                artist.text = "QUIT"
                artist.style = .Square
            case .Back:
                artist.text = "<"
                artist.style = .Square
            case .Next:
                artist.text = ">"
                artist.style = .Square
            case .Prev:
                artist.text = "<"
                artist.style = .Square
            case let .Level(lvl):
                artist.text = "\(lvl)"
                artist.style = .Square
            }
            return artist
        case let .Enemy(type):
            let artist: EnemyArtist
            switch type {
            case .Soldier:
                artist = EnemyArtist()
                artist.size = CGSize(10)
            case .Leader:
                artist = BigEnemyArtist()
                artist.size = CGSize(20)
            case .Scout:
                artist = FastEnemyArtist()
                artist.size = CGSize(10)
            case .Dozer:
                artist = EnemyArtist()
                artist.size = CGSize(width: 5, height: 50)
            }
            return artist
        case let .EnemyShrapnel(type):
            let artist: EnemyArtist
            switch type {
            case .Soldier:
                artist = EnemyArtist()
                artist.size = CGSize(10)
            case .Leader:
                artist = BigEnemyArtist()
                artist.size = CGSize(20)
            case .Scout:
                artist = FastEnemyArtist()
                artist.size = CGSize(10)
            case .Dozer:
                artist = EnemyArtist()
                artist.size = CGSize(width: 5, height: 50)
            }
            artist.size = artist.size * 0.1
            return artist
        case .Cursor:
            let artist = CursorArtist()
            return artist
        case let .Drone(upgrade):
            let artist = DroneArtist()
            artist.size = CGSize(20)
            artist.upgrade = upgrade
            return artist
        case let .Radar(upgrade):
            let artist = RadarArtist(upgrade: upgrade)
            return artist
        case let .Base(upgrade, health):
            let artist = BaseArtist(upgrade: upgrade)
            artist.health = health
            artist.size = CGSize(40)
            return artist
        case let .BaseSingleTurret(upgrade):
            let artist = BaseTurretArtist(upgrade: upgrade)
            artist.size = CGSize(48)
            return artist
        case let .BaseDoubleTurret(upgrade):
            let artist = BaseDoubleTurretArtist(upgrade: upgrade)
            artist.size = CGSize(48)
            return artist
        case let .BaseBigTurret(upgrade):
            let artist = BaseBigTurretArtist(upgrade: upgrade)
            artist.size = CGSize(48)
            return artist
        case let .BaseTurretBullet(upgrade):
            let artist = BaseTurretBulletArtist(upgrade: upgrade)
            artist.size = BaseTurretBulletArtist.bulletSize(upgrade)
            return artist
        default:
            return Artist()
        }
    }

}
