//
//  HourglassZoneArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class HourglassZoneArtist: Artist {
    var color = UIColor(hex: PowerupRed)

    required init() {
        super.init()
        size = CGSize(HourglassSize)
    }

    override func draw(context: CGContext) {
        let lineWidth: CGFloat = 1
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextAddEllipseInRect(context, CGRect(origin: .zero, size: size))
        CGContextDrawPath(context, .Stroke)
    }

}
