//  EnemyDiamondArtist.swift
//
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyDiamondArtist: Artist {
    private var color = UIColor(hex: EnemySoldierGreen)
    private var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(20, 11.547005383792516)
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func drawingOffset(scale: Scale) -> CGPoint {
        return .zero
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)

        if health < 1 {
            let x = size.width * health
            if x > middle.x {
                let y1 = interpolate(x, from: (size.width, middle.x), to: (middle.y, 0))
                let y2 = size.height - y1
                CGContextMoveToPoint(context, x, y1)
                CGContextAddLineToPoint(context, middle.x, 0)
                CGContextAddLineToPoint(context, 0, middle.y)
                CGContextAddLineToPoint(context, middle.x, size.height)
                CGContextAddLineToPoint(context, x, y2)
                CGContextClosePath(context)
            }
            else {
                let y1 = interpolate(x, from: (0, middle.x), to: (middle.y, 0))
                let y2 = size.height - y1
                CGContextMoveToPoint(context, x, y1)
                CGContextAddLineToPoint(context, 0, middle.y)
                CGContextAddLineToPoint(context, x, y2)
                CGContextClosePath(context)
            }
            CGContextDrawPath(context, .Fill)
            CGContextSetAlpha(context, 0.25)
        }

        CGContextMoveToPoint(context, size.width, middle.y)
        CGContextAddLineToPoint(context, middle.x, 0)
        CGContextAddLineToPoint(context, 0, middle.y)
        CGContextAddLineToPoint(context, middle.x, size.height)
        CGContextClosePath(context)
        CGContextDrawPath(context, .Fill)
    }

}
