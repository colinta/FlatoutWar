//
//  ShieldPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ShieldPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let segmentCount = 15
        let arcMargin = 3.degrees
        let arc = TAU / CGFloat(segmentCount) - arcMargin
        let outerRadius = size.width / 2
        let innerRadius = outerRadius - 3

        CGContextAddEllipseInRect(context, middle.rectWithSize(CGSize(r: innerRadius)))
        CGContextDrawPath(context, .Fill)

        CGContextTranslateCTM(context, middle.x, middle.y)
        var angle: CGFloat = (arc + arcMargin) / 2
        segmentCount.times {
            let start = CGPoint(r: innerRadius, a: angle)
            CGContextMoveToPoint(context, start.x, start.y)
            CGContextAddArc(context, 0, 0, outerRadius, angle, angle + arc, 0)
            CGContextAddArc(context, 0, 0, innerRadius, angle + arc, angle, 1)
            CGContextClosePath(context)
            CGContextDrawPath(context, .FillStroke)
            angle += arc + arcMargin
        }
    }

}
