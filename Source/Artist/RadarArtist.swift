//
//  RadarArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RadarArtist: Artist {
    var sweepAngle: CGFloat
    var radius: CGFloat
    var color = UIColor(hex: 0xFCF10C)

    required init(upgrade: FiveUpgrades) {
        switch upgrade {
        case .One:
            radius = 300
            sweepAngle = 30.degrees
        case .Two:
            radius = 312
            sweepAngle = 32.5.degrees
        case .Three:
            radius = 324
            sweepAngle = 35.degrees
        case .Four:
            radius = 336
            sweepAngle = 37.5.degrees
        case .Five:
            radius = 360
            sweepAngle = 42.5.degrees
        }

        super.init()

        size = CGSize(width: radius * cos(sweepAngle / 2), height: 2 * radius * sin(sweepAngle / 2))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, 1.pixels)

        let p0 = CGPoint(x: 0, y: middle.y)
        let p1 = CGPoint(x: size.width, y: 0)
        let p2 = CGPoint(x: size.width, y: size.height)
        let p3 = CGPoint(x: size.width, y: middle.y)

        CGContextSaveGState(context)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [ 0.9882, 0.9451, 0.0471, 0.25,
                                  0.2471, 0.2471, 0.2471, 0.0]
        let locations: [CGFloat] = [0, 1]
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)!
        CGContextMoveToPoint(context, p1.x, p1.y)
        CGContextAddLineToPoint(context, p0.x, p0.y)
        CGContextAddLineToPoint(context, p2.x, p2.y)
        CGContextClip(context)
        CGContextDrawLinearGradient(context, gradient, p0, p3, [])
        CGContextRestoreGState(context)

        CGContextSetAlpha(context, 0.5)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, p1.x, p1.y)
        CGContextAddLineToPoint(context, p0.x, p0.y)
        CGContextAddLineToPoint(context, p2.x, p2.y)
        CGContextDrawPath(context, .Stroke)

        CGContextSetAlpha(context, 0.25)
        CGContextMoveToPoint(context, p0.x, p0.y)
        CGContextAddLineToPoint(context, radius, middle.y)
        CGContextDrawPath(context, .Stroke)
    }
}
