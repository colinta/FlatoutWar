//
//  DroneArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/1/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneArtist: Artist {
    var stroke = UIColor(hex: 0x25B1FF)
    var upgrade = FiveUpgrades.Default
    var health: CGFloat

    required init(upgrade: FiveUpgrades, health: CGFloat) {
        self.upgrade = upgrade
        self.health = health

        super.init()
        shadowed = .True
        size = CGSize(20)
    }

    required init() {
        fatalError("init() has not been implemented")
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
        CGContextSetShadowWithColor(context, .Zero, 5, stroke.CGColor)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, stroke.CGColor)
        CGContextSetLineWidth(context, 2)

        let outerRadius: CGFloat = 1
        let innerRadius: CGFloat = 1.5
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
            if health == 1 {
                CGContextMoveToPoint(context, middle.x, outerRadius)
                CGContextAddLineToPoint(context, middle.x, size.height - outerRadius)
                CGContextMoveToPoint(context, outerRadius, middle.y)
                CGContextAddLineToPoint(context, size.width - outerRadius, middle.y)

                CGContextDrawPath(context, .Stroke)
            }
            else {
                CGContextSetAlpha(context, 0.5)
                CGContextMoveToPoint(context, outerRadius, middle.y)
                CGContextAddLineToPoint(context, size.width - outerRadius, middle.y)
                CGContextMoveToPoint(context, middle.x, outerRadius)
                CGContextAddLineToPoint(context, middle.x, size.height - outerRadius)
                CGContextDrawPath(context, .Stroke)

                CGContextSetAlpha(context, 1)
                CGContextMoveToPoint(context, interpolate(health, from: (1, 0), to: (outerRadius, size.width - outerRadius)), middle.y)
                CGContextAddLineToPoint(context, size.width - outerRadius, middle.y)
                CGContextMoveToPoint(context, middle.x, interpolate(health, from: (1, 0), to: (outerRadius, size.height - outerRadius)))
                CGContextAddLineToPoint(context, middle.x, size.height - outerRadius)
                CGContextDrawPath(context, .Stroke)
            }
        }
    }

}
