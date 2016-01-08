//
//  PercentArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum PercentStyle {
    static let Default: PercentStyle = .Green
    case Green
    case Heat
}

class PercentArtist: Artist {
    var complete: CGFloat = 1.0
    private var color = UIColor(hex: 0x3E8012)
    var style: PercentStyle
    var completeColor = UIColor(hex: 0x5BBC1A)

    required init(style: PercentStyle) {
        self.style = style
        super.init()
        size = CGSize(width: 40, height: 5)
    }

    required convenience init() {
        self.init(style: .Default)
    }

    override func draw(context: CGContext) {
        CGContextSetAlpha(context, 0.5)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        CGContextDrawPath(context, .Fill)

        let smallWidth = size.width * complete
        CGContextSetFillColorWithColor(context, completeColor.CGColor)
        CGContextAddRect(context, CGRect(x: 0, y: 0, width: smallWidth, height: size.height))
        CGContextDrawPath(context, .Fill)
    }

}
