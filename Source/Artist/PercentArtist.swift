//
//  PercentArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum PercentStyle {
    static let Default: PercentStyle = .Experience
    case Experience
    case Resource
    case Heat

    var color: Int {
        switch self {
        case .Experience: return 0x3E8012
        case .Resource: return 0xFFFFFF
        default: return 0
        }
    }
    var completeColor: Int {
        switch self {
        case .Experience: return 0x5BBC1A
        case .Resource: return ResourceBlue
        default: return 0
        }
    }

}

class PercentArtist: Artist {
    var complete: CGFloat = 1.0
    var style: PercentStyle

    required init(style: PercentStyle) {
        self.style = style
        super.init()
        switch style {
        case .Experience:
            size = CGSize(width: 60, height: 5)
        case .Resource:
            size = CGSize(width: 60, height: 4)
        case .Heat:
            size = CGSize(width: 4, height: 35)
        }
    }

    required convenience init() {
        self.init(style: .Default)
    }

    override func draw(context: CGContext) {
        switch style {
        case .Experience, .Resource:
            let smallWidth = size.width * complete
            CGContextSetAlpha(context, 0.5)
            CGContextSetFillColorWithColor(context, UIColor(hex: style.color).CGColor)
            CGContextAddRect(context, CGRect(origin: .zero, size: size))
            CGContextDrawPath(context, .Fill)

            CGContextSetAlpha(context, 1)
            CGContextSetFillColorWithColor(context, UIColor(hex: style.completeColor).CGColor)
            CGContextAddRect(context, CGRect(origin: .zero, size: CGSize(smallWidth, size.height)))
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
