//
//  NoPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NoPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        CGContextTranslateCTM(context, middle.x, middle.y)
        CGContextRotateCTM(context, 45.degrees)

        let smallR: CGFloat = 2
        let bigR: CGFloat = middle.x
        CGContextMoveToPoint(context, -bigR, smallR)
        CGContextAddLineToPoint(context, -bigR, -smallR)
        CGContextAddLineToPoint(context, -smallR, -smallR)
        CGContextAddLineToPoint(context, -smallR, -bigR)
        CGContextAddLineToPoint(context, smallR, -bigR)
        CGContextAddLineToPoint(context, smallR, -smallR)
        CGContextAddLineToPoint(context, bigR, -smallR)
        CGContextAddLineToPoint(context, bigR, smallR)
        CGContextAddLineToPoint(context, smallR, smallR)
        CGContextAddLineToPoint(context, smallR, bigR)
        CGContextAddLineToPoint(context, -smallR, bigR)
        CGContextAddLineToPoint(context, -smallR, smallR)
        CGContextClosePath(context)

        CGContextDrawPath(context, .FillStroke)
    }

}
