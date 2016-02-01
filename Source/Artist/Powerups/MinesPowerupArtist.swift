//
//  MinesPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class MinesPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let outerRadius = size.width / 3
        let innerRadius = outerRadius - 2
        let segmentCount = 8
        let smallArc: CGFloat = 10.degrees
        let arc = TAU / CGFloat(segmentCount)

        CGContextTranslateCTM(context, middle.x, middle.y)
        var angle: CGFloat = -smallArc / 2
        var first = true
        segmentCount.times {
            let p1 = CGPoint(r: innerRadius, a: angle)
            let p2 = CGPoint(r: outerRadius, a: angle)
            let p3 = CGPoint(r: outerRadius, a: angle + smallArc)
            let p4 = CGPoint(r: innerRadius, a: angle + smallArc)
            if first {
                CGContextMoveToPoint(context, p1.x, p1.y)
            }
            else {
                CGContextAddLineToPoint(context, p1.x, p1.y)
            }
            CGContextAddLineToPoint(context, p2.x, p2.y)
            CGContextAddLineToPoint(context, p3.x, p3.y)
            CGContextAddLineToPoint(context, p4.x, p4.y)
            angle += arc
            first = false
        }
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
