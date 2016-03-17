//
//  ShieldSegmentArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class ShieldSegmentArtist: PowerupArtist {
    var color = UIColor(hex: PowerupRed)
    var health: CGFloat = 1

    required init() {
        super.init()
        size = CGSize(width: 5, height: 25)
    }

    override func draw(context: CGContext) {
        super.draw(context)

        let segmentCount = 15
        let arc = TAU / CGFloat(segmentCount)
        let outerRadius: CGFloat = 60
        let outerWidth: CGFloat = 3
        let innerRadius = outerRadius - outerWidth

        CGContextTranslateCTM(context, -55, middle.y)
        CGContextSetAlpha(context, health)

        let angle: CGFloat = -arc / 2
        let start = CGPoint(r: innerRadius, a: angle)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddArc(context, 0, 0, outerRadius, angle, angle + arc, 0)
        CGContextAddArc(context, 0, 0, innerRadius, angle + arc, angle, 1)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
