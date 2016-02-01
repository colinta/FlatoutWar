//
//  NetPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NetPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        CGContextAddEllipseInRect(context, middle.rectWithSize(size))
        CGContextDrawPath(context, .FillStroke)

        let r = size.width / 2
        let rr = pow(r, 2)
        let dx = size.width / 4
        let dy = size.height / 4

        CGContextTranslateCTM(context, middle.x, middle.y)
        for s in [-1, 0, 1] as [CGFloat] {
            let x = s * dx
            let y1: CGFloat = sqrt(rr - pow(x, 2))
            let y2 = -y1
            CGContextMoveToPoint(context, x, y1)
            CGContextAddLineToPoint(context, x, y2)

            let y = s * dy
            let x1: CGFloat = sqrt(rr - pow(y, 2))
            let x2 = -x1
            CGContextMoveToPoint(context, x1, y)
            CGContextAddLineToPoint(context, x2, y)
        }
        CGContextDrawPath(context, .Stroke)
    }

}
