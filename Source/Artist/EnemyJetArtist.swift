//
//  EnemyJetArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyJetArtist: Artist {
    private var color = UIColor(hex: 0xFA5BDD)
    private var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(8)
        shadowed = .True
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetShadowWithColor(context, CGSizeZero, 5, color.CGColor)

        if health == 1 {
            CGContextMoveToPoint(context, size.width, middle.y)
            CGContextAddLineToPoint(context, 0, size.height)
            CGContextAddLineToPoint(context, 0, 0)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)
        }
        else {
            let x = size.width * (1 - health)
            let deltaY = health * size.height / 2

            CGContextMoveToPoint(context, size.width, middle.y)
            CGContextAddLineToPoint(context, x, middle.y + deltaY)
            CGContextAddLineToPoint(context, x, middle.y - deltaY)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)

            CGContextSetAlpha(context, 0.25)
            CGContextMoveToPoint(context, size.width, middle.y)
            CGContextAddLineToPoint(context, 0, size.height)
            CGContextAddLineToPoint(context, 0, 0)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)
        }
    }

}

class EnemyBigJetArtist: EnemyJetArtist {
    private let darkColor = UIColor(hex: 0xAC3E97)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(16)
    }

    override func draw(context: CGContext) {

        CGContextSaveGState(context)
        super.draw(context)
        CGContextRestoreGState(context)

        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, darkColor.CGColor)
        CGContextMoveToPoint(context, size.width * 0.25, size.height * 0.125)
        CGContextAddLineToPoint(context, size.width * 0.25, size.height * 0.875)
        CGContextDrawPath(context, .Stroke)
    }

}

