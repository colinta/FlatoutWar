//
//  ShieldArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class ShieldArtist: PowerupArtist {
    var phase: CGFloat = 0

    required init() {
        super.init()
        size = CGSize(r: 57)
    }

    override func draw(context: CGContext) {
        super.draw(context)

        let smallR: CGFloat = 10
        let smallSize: CGSize = size - CGSize(r: smallR)
        let center1 = CGPoint(r: smallR, a: TAU * phase + TAU_3)
        let center2 = CGPoint(r: smallR, a: TAU * phase + TAU_2_3)
        let center3 = CGPoint(r: smallR, a: TAU * phase)
        CGContextTranslateCTM(context, middle.x, middle.y)
        CGContextAddEllipseInRect(context, center1.rect(size: smallSize))
        CGContextAddEllipseInRect(context, center2.rect(size: smallSize))
        CGContextAddEllipseInRect(context, center3.rect(size: smallSize))
        CGContextDrawPath(context, .Stroke)
    }

}
