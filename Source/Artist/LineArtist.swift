//
//  LineArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class LineArtist: Artist {
    let color: UIColor
    private let lineThickness: CGFloat = 1

    required init(_ length: CGFloat, _ color: UIColor) {
        self.color = color
        super.init()
        size = CGSize(width: length, height: lineThickness)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        let lineWidth = lineThickness.pixels
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextTranslateCTM(context, middle.x, middle.y)
        let p1 = CGPoint(x: 0, y: lineThickness.pixels)
        let p2 = CGPoint(x: size.width, y: lineThickness.pixels)
        CGContextMoveToPoint(context, p1.x, p1.y)
        CGContextAddLineToPoint(context, p2.x, p2.y)
        CGContextDrawPath(context, .Stroke)
    }

}
