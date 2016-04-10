//
//  DotArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/10/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DotArtist: Artist {
    var color = UIColor.whiteColor()

    required init() {
        super.init()
        size = CGSize(1)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        if size.width <= 1 {
            CGContextAddRect(context, CGRect(origin: .zero, size: size))
        }
        else {
            CGContextAddEllipseInRect(context, CGRect(origin: .zero, size: size))
        }
        CGContextDrawPath(context, .Fill)
    }

}
