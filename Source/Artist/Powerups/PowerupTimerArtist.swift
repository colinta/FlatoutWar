//
//  PowerupTimerArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PowerupTimerArtist: Artist {
    var fillColor = UIColor(hex: 0xA00917)
    var strokeColor = UIColor(hex: PowerupRed)
    var percent: CGFloat

    required init(percent: CGFloat) {
        self.percent = percent
        super.init()
        size = CGSize(30)
    }
    
    convenience required init() {
        self.init(percent: 1)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)

        let a0 = -TAU_4
        let a1 = a0 - TAU * percent
        let p0 = middle + CGPoint(0, -size.height / 2)
        let p1 = middle + CGPoint(r: size.height / 2, a: a1)
        CGContextMoveToPoint(context, middle.x, middle.y)
        CGContextAddLineToPoint(context, p0.x, p0.y)
        CGContextAddArc(context, middle.x, middle.y, size.height / 2, a0, a1, 1)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
