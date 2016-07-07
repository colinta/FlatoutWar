//
//  DroneArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/1/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

let DroneColor = 0x25B1FF

class DroneArtist: Artist {
    var stroke = UIColor(hex: DroneColor)
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
        case .Five, .Four, .Three, .Two:
            offset += CGPoint(x: 1.5, y: 1.5)
        case .One:
            break
        }

        return offset
    }

    override func draw(context: CGContext) {
        CGContextSetShadowWithColor(context, .zero, 5, stroke.CGColor)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, stroke.CGColor)
        CGContextSetLineWidth(context, 2)

        switch upgrade {
        case .Five:
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        case .Two:
            CGContextSetLineWidth(context, 4)
        default: break
        }

        let innerRadius: CGFloat = 1.5
        let ellipseRadius = innerRadius * 8
        switch upgrade {
        case .Five, .Four:
            if health == 1 {
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(ellipseRadius)))
                CGContextDrawPath(context, .Stroke)
            }
            else {
                CGContextSetAlpha(context, 0.5)
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(ellipseRadius)))
                CGContextDrawPath(context, .Stroke)

                CGContextSetAlpha(context, 1)
                let startAngle = interpolate(health, from: (1, 0), to: (0, TAU))
                let endAngle = TAU
                CGContextAddArc(context, middle.x, middle.y, ellipseRadius,
                    startAngle + TAU_3_8, endAngle + TAU_3_8, 0)
                CGContextDrawPath(context, .Stroke)
            }
            fallthrough
        case .Three:
            if health == 1 {
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
            }
            else {
                CGContextSetAlpha(context, 0.5)
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

                CGContextClipToRect(context, CGRect(
                    x: (1 - health) * size.width,
                    y: (1 - health) * size.height,
                    width: health * size.width,
                    height: health * size.height
                    ))
                CGContextSetAlpha(context, 1)
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
            }
        case .Two:
            CGContextSetLineWidth(context, 4)

            if health == 1 {
                CGContextMoveToPoint(context, middle.x, 0)
                CGContextAddLineToPoint(context, middle.x, size.height)
                CGContextMoveToPoint(context, 0, middle.y)
                CGContextAddLineToPoint(context, size.width, middle.y)
                CGContextDrawPath(context, .Stroke)
            }
            else {
                CGContextSetAlpha(context, 0.5)
                CGContextMoveToPoint(context, middle.x, 0)
                CGContextAddLineToPoint(context, middle.x, size.height)
                CGContextMoveToPoint(context, 0, middle.y)
                CGContextAddLineToPoint(context, size.width, middle.y)
                CGContextDrawPath(context, .Stroke)

                CGContextSetAlpha(context, 1)
                CGContextMoveToPoint(context, (1 - health) * size.width, middle.y)
                CGContextAddLineToPoint(context, size.width, middle.y)
                CGContextMoveToPoint(context, middle.x, (1 - health) * size.height)
                CGContextAddLineToPoint(context, middle.x, size.height)
                CGContextDrawPath(context, .Stroke)
            }
        case .One:
            let outerRadius: CGFloat = 1
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
