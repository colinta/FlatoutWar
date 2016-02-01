//
//  BaseTurretBulletArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/17/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseTurretBulletArtist: Artist {
    var color = UIColor(hex: 0x9F0025)
    var upgrade = FiveUpgrades.Default

    static func bulletSize(upgrade: FiveUpgrades) -> CGSize {
        switch upgrade {
        case .One:
            return 3 * CGSize(width: 2, height: 2)
        case .Two:
            return 3 * CGSize(width: 2.5, height: 1.6)
        case .Three:
            return 3 * CGSize(width: 3, height: 1.333)
        case .Four:
            return 3 * CGSize(width: 3.5, height: 1.142)
        case .Five:
            return 3 * CGSize(width: 4, height: 0.25)
        }
    }

    required init(upgrade: FiveUpgrades) {
        self.upgrade = upgrade
        super.init()
        size = BaseTurretBulletArtist.bulletSize(upgrade)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        let r = size.width / 2
        let bulletSize = r * BaseTurretBulletArtist.bulletSize(upgrade)

        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        if bulletSize.width == bulletSize.height {
            CGContextAddEllipseInRect(context, CGRect(origin: .Zero, size: size))
            CGContextDrawPath(context, .Fill)
        }
        else {
            let r = bulletSize.height / 2
            CGContextMoveToPoint(context, middle.x - bulletSize.width / 2  + r, middle.y - r)
            CGContextAddArc(context, middle.x + bulletSize.width / 2 - r, middle.y, r, -TAU_4, TAU_4, 0)
            CGContextAddArc(context, middle.x - bulletSize.width / 2  + r, middle.y, r, TAU_4, -TAU_4, 0)
            CGContextDrawPath(context, .Fill)
        }
    }

}
