//
//  BomberPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BomberPowerupArtist: PowerupArtist {
    required init() {
        super.init()
        rotation = -45.degrees
    }

    override func draw(context: CGContext) {
        super.draw(context)

        let margin: CGFloat = 5
        let maxDim = min(size.width, size.height) - margin
        let minDim = margin
        let centerDim = (maxDim + minDim) / 2
        let innerX = minDim + (maxDim - minDim) / 7
        CGContextMoveToPoint(context, maxDim, centerDim)
        CGContextAddLineToPoint(context, minDim, maxDim)
        CGContextAddLineToPoint(context, innerX, centerDim)
        CGContextAddLineToPoint(context, minDim, minDim)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)

        let dist: CGFloat = 5
        let angle = atan2(centerDim - minDim, maxDim - minDim)
        let smallDim: CGFloat = 3

        var x = maxDim, y1 = centerDim, y2 = centerDim - smallDim
        for _ in 0..<4 {
            x -= dist * cos(angle)
            y1 += dist * sin(angle)
            y2 -= dist * sin(angle)
            for y in [y1, y2] {
                let rect = CGRect(
                    x: x, y: y,
                    width: smallDim, height: smallDim
                )
                CGContextAddEllipseInRect(context, rect)
            }
            CGContextDrawPath(context, .FillStroke)
        }
    }

}
