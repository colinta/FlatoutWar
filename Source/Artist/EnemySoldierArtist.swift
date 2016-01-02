//
//  EnemySoldierArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemySoldierArtist: Artist {
    private var color = UIColor(hex: 0x3E8012)
    private var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(10)
        shadowed = .True
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetShadowWithColor(context, CGSizeZero, 5, color.CGColor)

        if health == 1 {
            CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
            CGContextDrawPath(context, .Fill)
        }
        else {
            let x = size.width * (1 - health)

            CGContextAddRect(context, CGRect(x: x, y: 0, width: size.width - x, height: size.height))
            CGContextDrawPath(context, .Fill)

            CGContextSetAlpha(context, 0.25)
            CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
            CGContextDrawPath(context, .Fill)
        }
    }

}

class EnemyLeaderArtist: EnemySoldierArtist {
    private let darkColor = UIColor(hex: 0x234B0C)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(20)
    }

    override func draw(context: CGContext) {
        CGContextSaveGState(context)
        super.draw(context)
        CGContextRestoreGState(context)

        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, darkColor.CGColor)
        CGContextMoveToPoint(context, size.width * 0.75, 0)
        CGContextAddLineToPoint(context, size.width * 0.75, size.height)
        CGContextDrawPath(context, .Stroke)
    }

}


class EnemyScoutArtist: EnemySoldierArtist {
    private let darkColor = UIColor(hex: 0xBCA600)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(8)
        color = UIColor(hex: 0xEED200)
    }

    override func draw(context: CGContext) {
        CGContextSaveGState(context)
        super.draw(context)
        CGContextRestoreGState(context)

        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, darkColor.CGColor)
        let stroke: CGFloat = 0.5
        CGContextMoveToPoint(context, size.width * 0.75 + stroke, 0)
        CGContextAddLineToPoint(context, size.width * 0.75 - stroke, 0)
        CGContextAddLineToPoint(context, size.width * 0.25 - stroke, size.height)
        CGContextAddLineToPoint(context, size.width * 0.25 + stroke, size.height)
        CGContextDrawPath(context, .Fill)
    }

}

class EnemyDozerArtist: EnemySoldierArtist {

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(width: 5, height: 50)
    }

}