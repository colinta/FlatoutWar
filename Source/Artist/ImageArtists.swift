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
            case .Leader:
                artist = BigEnemyArtist()
            case .Scout:
                artist = FastEnemyArtist()
            case .Dozer:
                artist = DozerEnemyArtist()
            }
            return artist
        case let .EnemyShrapnel(type):
            let artist = ImageIdentifier.Enemy(type: type).artist
            artist.size = artist.size * 0.1
            return artist
        case .Cursor:
            let artist = CursorArtist()
            return artist
        case let .Drone(upgrade):
            let artist = DroneArtist(upgrade: upgrade)
            return artist
        case let .Radar(upgrade):
            let artist = RadarArtist(upgrade: upgrade)
            return artist
        case let .Base(upgrade, health):
            let artist = BaseArtist(upgrade: upgrade)
            artist.health = health
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
