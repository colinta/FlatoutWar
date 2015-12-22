//
//  DrawerArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/1/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DrawerArtist: Artist {
    var background = UIColor(hex: 0x0029E9)
    var foreground = UIColor(hex: 0x82A4FF)
    var phase = CGFloat(0)
    private let barsPath: CGMutablePath
    private let delta = CGFloat(15)

    required init() {
        barsPath = CGPathCreateMutable()
        let width = CGFloat(80) + delta
        let height = CGFloat(400) + 2 * delta
        for var x = CGFloat(0); x < width; x += delta {
            CGPathMoveToPoint(barsPath, nil, x, 0)
            CGPathAddLineToPoint(barsPath, nil, x, height)
        }
        for var y = CGFloat(0); y < height; y += delta {
            CGPathMoveToPoint(barsPath, nil, 0, y)
            CGPathAddLineToPoint(barsPath, nil, width, y)
        }
        super.init()
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, background.CGColor)
        CGContextSetStrokeColorWithColor(context, foreground.CGColor)
        CGContextSetAlpha(context, 1)
        CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
        CGContextDrawPath(context, .FillStroke)

        CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
        CGContextClip(context)
        CGContextTranslateCTM(context, delta * (phase - 1), 2 * delta * (phase - 1))
        CGContextAddPath(context, barsPath)
        CGContextDrawPath(context, .Stroke)
    }

}
