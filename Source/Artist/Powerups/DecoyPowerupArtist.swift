//
//  DecoyPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DecoyPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let scaleDown: CGFloat = 0.75
        CGContextTranslateCTM(context, middle.x, middle.y)
        CGContextScaleCTM(context, scaleDown, scaleDown)
        CGContextRotateCTM(context, -45.degrees)

        let playerSize = CGSize(size.width / scaleDown)
        CGContextAddEllipseInRect(context, CGPoint.zero.rectWithSize(playerSize))
        CGContextDrawPath(context, .FillStroke)

        let bigR: CGFloat = 5
        let smallR: CGFloat = 3.5
        let tinyR: CGFloat = 1
        let width: CGFloat = 24
        CGContextMoveToPoint(context, -bigR, -tinyR)
        CGContextAddLineToPoint(context, 0, -bigR)
        CGContextAddLineToPoint(context, width, -smallR)
        CGContextAddLineToPoint(context, width, smallR)
        CGContextAddLineToPoint(context, 0, bigR)
        CGContextAddLineToPoint(context, -bigR, tinyR)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
