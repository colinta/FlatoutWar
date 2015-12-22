//
//  ShapeArtists.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/25/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class ShapeArtist: Artist {
    var color = UIColor.whiteColor()
    var lineWidth: CGFloat?
    var drawingMode: CGPathDrawingMode = .Fill

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        if let lineWidth = lineWidth {
            CGContextSetLineWidth(context, lineWidth)
        }
        CGContextSetStrokeColorWithColor(context, color.CGColor)
    }
}

class RectArtist: ShapeArtist {
    override func draw(context: CGContext) {
        super.draw(context)
        CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
        CGContextDrawPath(context, drawingMode)
    }
}

class CircleArtist: ShapeArtist {
    override func draw(context: CGContext) {
        super.draw(context)
        CGContextAddEllipseInRect(context, CGRect(origin: CGPointZero, size: size))
        CGContextDrawPath(context, drawingMode)
    }
}
