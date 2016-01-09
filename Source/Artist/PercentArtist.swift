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
        switch style {
        case .Green:
            size = CGSize(width: 40, height: 5)
        case .Heat:
            size = CGSize(width: 4, height: 35)
        }
    }

    required convenience init() {
        self.init(style: .Default)
    }

    override func draw(context: CGContext) {
        switch style {
        case .Green:
            CGContextSetAlpha(context, 0.5)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextAddRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: size))
            CGContextDrawPath(context, .Fill)

            let smallWidth = size.width * complete
            CGContextSetFillColorWithColor(context, completeColor.CGColor)
            CGContextAddRect(context, CGRect(x: 0, y: 0, width: smallWidth, height: size.height))
            CGContextDrawPath(context, .Fill)
        case .Heat:
            let smallHeight = size.height * complete
            CGContextAddRect(context, CGRect(x: 0, y: size.height - smallHeight, width: size.width, height: smallHeight))
            CGContextClip(context)

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let components: [CGFloat] = [1.0, 1.0, 0, 1,
                                      1.0, 0, 0, 1]
            let locations: [CGFloat] = [0, 1]
            let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)!
            CGContextDrawLinearGradient(context, gradient, CGPoint(y: 0), CGPoint(y: size.height), [])
        }
    }

}
