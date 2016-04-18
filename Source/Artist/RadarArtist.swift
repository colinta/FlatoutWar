//
//  RadarArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension FiveUpgrades {
    var baseRadarColor: Int {
        switch self {
            case .One: return 0xFCF10C
            case .Two: return 0xEFDD15
            case .Three: return 0xEBAD13
            case .Four: return 0xE59311
            case .Five: return 0xDD6610
        }
    }
}

class RadarArtist: Artist {
    var sweepAngle: CGFloat
    var radius: CGFloat
    var color: UIColor

    required init(radius: CGFloat, sweepAngle: CGFloat, color: UIColor) {
        self.radius = radius
        self.sweepAngle = sweepAngle
        self.color = color

        super.init()

        size = CGSize(width: radius * cos(sweepAngle), height: 2 * radius * sin(sweepAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, 1.pixels)

        let innerRadius: CGFloat = 25
        let c0 = CGPoint(x: 0, y: middle.y)
        let centerRight = CGPoint(x: size.width, y: middle.y)
        let centerInner = CGPoint(x: innerRadius, y: middle.y)

        let topRight = CGPoint(x: size.width, y: size.height)
        //let topInner = CGPoint(r: innerRadius, a: sweepAngle) + CGPoint(x: 0, y: size.height / 2)

        let bottomRight = CGPoint(x: size.width, y: 0)
        let bottomInner = CGPoint(r: innerRadius, a: -sweepAngle) + CGPoint(x: 0, y: size.height / 2)

        CGContextSaveGState(context)
        CGContextMoveToPoint(context, bottomRight.x, bottomRight.y)
        CGContextAddLineToPoint(context, bottomInner.x, bottomInner.y)
        CGContextAddArc(context, c0.x, c0.y, innerRadius, -sweepAngle, sweepAngle, 0)
        CGContextAddLineToPoint(context, topRight.x, topRight.y)
        CGContextClosePath(context)
        CGContextClip(context)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [ 0.9882, 0.9451, 0.0471, 0.25,
                                  0.2471, 0.2471, 0.2471, 0.0]
        let locations: [CGFloat] = [0, 1]
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)!
        CGContextDrawLinearGradient(context, gradient, c0, centerRight, [])
        CGContextRestoreGState(context)

        CGContextSetAlpha(context, 0.5)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, bottomRight.x, bottomRight.y)
        CGContextAddLineToPoint(context, bottomInner.x, bottomInner.y)
        CGContextAddArc(context, c0.x, c0.y, innerRadius, -sweepAngle, sweepAngle, 0)
        CGContextAddLineToPoint(context, topRight.x, topRight.y)
        CGContextDrawPath(context, .Stroke)

        CGContextSetAlpha(context, 0.25)
        CGContextMoveToPoint(context, centerInner.x, centerInner.y)
        CGContextAddLineToPoint(context, radius, middle.y)
        CGContextDrawPath(context, .Stroke)
    }
}
