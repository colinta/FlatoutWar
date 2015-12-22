//
//  DroneArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/1/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneRadarArtist: Artist {
    var phase = CGFloat(0)
    var stroke = UIColor(hex: 0x25B1FF)
    var radarRadius: CGFloat?

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        if let radarRadius = radarRadius where phase > 0.5 {
            CGContextSetLineWidth(context, 1)
            if phase < 0.9 {
                let phase1 = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
                let alpha1 = interpolate(phase, from: (0.6, 0.8), to: (0.25, 0))
                let drawingRadius = radarRadius * phase1
                CGContextSetAlpha(context, alpha1)
                CGContextAddEllipseInRect(context, middle.rectWithSize(CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }

            if phase > 0.6 {
                let phase2 = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
                let alpha2 = interpolate(phase, from: (0.8, 1.0), to: (0.25, 0))
                let drawingRadius = radarRadius * phase2
                CGContextSetAlpha(context, alpha2)
                CGContextAddEllipseInRect(context, middle.rectWithSize(CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }
        }
    }
}

class DroneArtist: Artist {
    var stroke = UIColor(hex: 0x25B1FF)
    var upgrade = FiveUpgrades.Default

    required init() {
        super.init()
        shadowed = .True
    }

    override func drawingOffset(scale: Scale) -> CGPoint {
        var offset = super.drawingOffset(scale)

        switch upgrade {
        case .Five:
            offset += CGPoint(x: 1.5, y: 1.5)
        case .Four:
            offset += CGPoint(x: 1.5, y: 1.5)
        case .Three:
            offset += CGPoint(x: 1.5, y: 1.5)
        case .Two:
            offset += CGPoint(x: 1.5, y: 1.5)
        case .One:
            break
        }

        return offset
    }

    override func draw(context: CGContext) {
        CGContextSetShadowWithColor(context, CGSizeZero, 5, stroke.CGColor)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, stroke.CGColor)
        CGContextSetLineWidth(context, 2)

        let outerRadius = CGFloat(1)
        let innerRadius = CGFloat(1.5)
        switch upgrade {
        case .Five:
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)

            CGContextAddEllipseInRect(context, middle.rectWithSize(CGSize(innerRadius * 8)))
            CGContextMoveToPoint(context, 0, middle.y - innerRadius)
            CGContextAddLineToPoint(context, 0, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y - innerRadius)
            CGContextClosePath(context)

            CGContextDrawPath(context, .Stroke)

        case .Four:
            CGContextSetLineWidth(context, 2)
            CGContextAddEllipseInRect(context, middle.rectWithSize(CGSize(innerRadius * 8)))
            fallthrough
        case .Three:
            CGContextMoveToPoint(context, 0, middle.y - innerRadius)
            CGContextAddLineToPoint(context, 0, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y - innerRadius)
            CGContextClosePath(context)

            CGContextDrawPath(context, .Stroke)

        case .Two:
            CGContextSetLineWidth(context, 4)

            CGContextMoveToPoint(context, middle.x, 0)
            CGContextAddLineToPoint(context, middle.x, size.height)
            CGContextMoveToPoint(context, 0, middle.y)
            CGContextAddLineToPoint(context, size.width, middle.y)

            CGContextDrawPath(context, .Stroke)
        case .One:
            CGContextMoveToPoint(context, middle.x, outerRadius)
            CGContextAddLineToPoint(context, middle.x, size.height - outerRadius)
            CGContextMoveToPoint(context, outerRadius, middle.y)
            CGContextAddLineToPoint(context, size.width - outerRadius, middle.y)

            CGContextDrawPath(context, .Stroke)
        }
    }

}
