//
//  PercentArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class PercentArtist: Artist {
    var complete = CGFloat(1.0)
    var color = UIColor(hex: 0x3E8012)

    override func draw(context: CGContext) {
        CGContextSetAlpha(context, 0.5)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        CGContextDrawPath(context, .Fill)

        let smallWidth = size.width * complete
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, CGRect(x: 0, y: 0, width: smallWidth, height: size.height))
        CGContextDrawPath(context, .Fill)
    }

}
