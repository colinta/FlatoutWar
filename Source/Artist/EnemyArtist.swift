//
//  EnemyArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyArtist: Artist {
    private var color = UIColor(hex: 0x3E8012)

    required init() {
        super.init()
        size = CGSize(10)
        shadowed = .True
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetShadowWithColor(context, CGSizeZero, 5, color.CGColor)
        CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
        CGContextDrawPath(context, .Fill)
    }

}

class BigEnemyArtist: EnemyArtist {

    required init() {
        super.init()
        size = CGSize(20)
    }

    override func draw(context: CGContext) {
        let darkColor = UIColor(hex: 0x234B0C)

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


class FastEnemyArtist: EnemyArtist {

    required init() {
        super.init()
        size = CGSize(10)
        color = UIColor(hex: 0xEED200)
    }

    override func draw(context: CGContext) {
        let darkColor = UIColor(hex: 0xBCA600)

        CGContextSaveGState(context)
        super.draw(context)
        CGContextRestoreGState(context)

        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, darkColor.CGColor)
        let stroke = CGFloat(0.5)
        CGContextMoveToPoint(context, size.width * 0.75 + stroke, 0)
        CGContextAddLineToPoint(context, size.width * 0.75 - stroke, 0)
        CGContextAddLineToPoint(context, size.width * 0.25 - stroke, size.height)
        CGContextAddLineToPoint(context, size.width * 0.25 + stroke, size.height)
        CGContextDrawPath(context, .Fill)
    }

}

class DozerEnemyArtist: EnemyArtist {

    required init() {
        super.init()
        size = CGSize(width: 5, height: 50)
    }

}
