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

        let pulseRadii: [CGFloat] = [
            15,
            12,
            7.5,
        ]
        CGContextTranslateCTM(context, middle.x, middle.y)
        for pulseRadius in pulseRadii {
            CGContextAddEllipseInRect(context, CGPoint.zero.rect(size: CGSize(r: pulseRadius)))
            CGContextDrawPath(context, .FillStroke)
        }
    }

}
