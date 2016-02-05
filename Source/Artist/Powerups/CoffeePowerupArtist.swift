//
//  CoffeePowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class CoffeePowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let bigR: CGFloat = 10
        let smallR: CGFloat = 3
        let mugHeight: CGFloat = size.height * 0.6
        let handleHeight = mugHeight * 0.8
        let handleThickness: CGFloat = 3
        let handleWidth: CGFloat = 8
        let handleLeft: CGFloat = 2
        let handleUp: CGFloat = 3

        CGContextTranslateCTM(context, bigR + handleWidth / 2, size.height - mugHeight / 2 - smallR)
        CGContextMoveToPoint(context, -bigR, mugHeight / 2)
        CGContextAddLineToPoint(context, -bigR, -mugHeight / 2)

        let arcRadius = mugHeight / 2 + smallR
        CGContextAddCurveToPoint(context,
            -smallR, -arcRadius,
            smallR, -arcRadius,
            bigR, -mugHeight / 2)
        CGContextAddLineToPoint(context, bigR, mugHeight / 2)
        CGContextAddCurveToPoint(context,
            smallR, arcRadius,
            -smallR, arcRadius,
            -bigR, mugHeight / 2)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)

        // inner mug edge
        CGContextMoveToPoint(context, -bigR, -mugHeight / 2)
        CGContextAddCurveToPoint(context,
            -smallR, -arcRadius + smallR * 2,
            smallR, -arcRadius + smallR * 2,
            bigR, -mugHeight / 2)
        CGContextDrawPath(context, .Stroke)

        // steam lines
        let steamR: CGFloat = 3
        let steamHeight: CGFloat = 6
        let steamX: [CGFloat] = [-bigR / 2, 0, bigR / 2]
        for x in steamX {
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, x, -mugHeight / 2 - smallR)
            CGContextMoveToPoint(context, 0, 0)
            CGContextAddCurveToPoint(context,
                steamR, -steamHeight / 2,
                -steamR, -steamHeight / 2,
                0, -steamHeight)
            CGContextDrawPath(context, .Stroke)
            CGContextRestoreGState(context)
        }

        // mug handle
        CGContextTranslateCTM(context, bigR - handleLeft, 0)
        for pathFill in [true, false] {
            CGContextMoveToPoint(context, 0, -handleHeight / 2 + handleUp)
            CGContextAddCurveToPoint(context,
                handleWidth, -handleHeight / 2 - handleUp,
                handleWidth, handleHeight / 2 + handleUp,
                0, handleHeight / 2 - handleUp)
            if !pathFill {
                CGContextDrawPath(context, .Stroke)
                CGContextMoveToPoint(context, 0, handleHeight / 2 - handleUp - handleThickness)
            }
            else {
                CGContextAddLineToPoint(context, 0, handleHeight / 2 - handleUp - handleThickness)
            }
            CGContextAddCurveToPoint(context,
                handleWidth - handleThickness, handleHeight / 2 + handleUp - handleThickness,
                handleWidth - handleThickness, -handleHeight / 2 - handleUp + handleThickness,
                0, -handleHeight / 2 + handleUp + handleThickness)
            if pathFill {
                CGContextClosePath(context)
                CGContextDrawPath(context, .Fill)
            }
            else {
                CGContextDrawPath(context, .Stroke)
            }
        }
    }

}
