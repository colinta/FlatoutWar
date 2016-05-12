//
//  NetPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NetPowerupArtist: PowerupArtist {
    var fill = true
    var phase: CGFloat = 0

    override func draw(context: CGContext) {
        super.draw(context)

        CGContextAddEllipseInRect(context, middle.rect(size: size))
        if fill {
            CGContextDrawPath(context, .FillStroke)
        }
        else {
            CGContextDrawPath(context, .Stroke)
        }

        let r = size.width / 2
        let rr = pow(r, 2)
        let dx = size.width / 6
        let dy = size.height / 6

        CGContextSetAlpha(context, 0.5)
        CGContextTranslateCTM(context, middle.x, middle.y)
        let factor: CGFloat = abs(sin(phase * TAU) / 4)
        for s in [-1.5, -0.5, 0.5, 1.5] as [CGFloat] {
            let sign: CGFloat = abs(s) / s
            do {
                let x1 = (s + factor * sign) * dx
                let x2 = (s + factor * sign) * dx * 1.6
                let y0: CGFloat = 0
                let y1: CGFloat = sqrt(rr - pow(x1, 2))
                let y2 = -y1
                CGContextMoveToPoint(context, x1, y1)
                CGContextAddQuadCurveToPoint(context, x2, y0, x1, y2)
            }

            do {
                let y1 = (s + factor * sign) * dy
                let y2 = (s + factor * sign) * dy * 1.6
                let x0: CGFloat = 0
                let x1: CGFloat = sqrt(rr - pow(y1, 2))
                let x2 = -x1
                CGContextMoveToPoint(context, x1, y1)
                CGContextAddQuadCurveToPoint(context, x0, y2, x2, y1)
            }
        }
        CGContextDrawPath(context, .Stroke)
    }

}
