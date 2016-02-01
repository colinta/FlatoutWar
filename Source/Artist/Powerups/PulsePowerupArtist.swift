//
//  PulsePowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PulsePowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let pulseCount = 9
        let pulseRadius: CGFloat = 2.5
        let radius = size.width / 2 - pulseRadius
        let innerRadius = radius - pulseRadius
        let arc = TAU / CGFloat(pulseCount)

        CGContextTranslateCTM(context, middle.x, middle.y)
        var angle: CGFloat = 0
        pulseCount.times {
            let inner = CGPoint(r: innerRadius, a: angle)
            let center = CGPoint(r: radius, a: angle)
            CGContextMoveToPoint(context, 0, 0)
            CGContextAddLineToPoint(context, inner.x, inner.y)
            let arcAngle = TAU_2 + angle
            CGContextAddArc(context, center.x, center.y, pulseRadius, arcAngle, arcAngle + TAU, 0)
            CGContextClosePath(context)
            CGContextDrawPath(context, .FillStroke)
            angle += arc
        }
    }

}
