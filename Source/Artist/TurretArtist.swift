//
//  TurretArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/17/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TurretArtist: Artist {
    var baseColor = UIColor(hex: 0xFFEC24)
    var turretColor = UIColor(hex: 0xCDA715)
    var upgrade = FiveUpgrades.Default
    var health: CGFloat

    required init(upgrade: FiveUpgrades, health: CGFloat) {
        self.upgrade = upgrade
        self.health = health

        super.init()
        shadowed = .True
        size = CGSize(25)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset(scale: Scale) -> CGPoint {
        var offset = super.drawingOffset(scale)

        switch upgrade {
        case .Five, .Four, .Three, .Two, .One:
            offset += CGPoint(x: 1.5, y: 1.5)
        }

        return offset
    }

    override func draw(context: CGContext) {
        CGContextSetShadowWithColor(context, .zero, 5, baseColor.CGColor)
        CGContextSetFillColorWithColor(context, baseColor.CGColor)
        CGContextTranslateCTM(context, middle.x, middle.y)

        CGContextSaveGState(context)
        CGContextScaleCTM(context, 0.9, 0.9)
        let pointCount = 4 + upgrade.int
        let angleDelta = TAU / CGFloat(pointCount)
        let radius = size.width / 2
        var first = true
        if health == 1 {
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    CGContextMoveToPoint(context, point.x, point.y)
                    first = false
                }
                else {
                    CGContextAddLineToPoint(context, point.x, point.y)
                }
            }
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)
        }
        else {
            CGContextSetAlpha(context, 0.5)
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    CGContextMoveToPoint(context, point.x, point.y)
                    first = false
                }
                else {
                    CGContextAddLineToPoint(context, point.x, point.y)
                }
            }
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)

            CGContextSetAlpha(context, 1)
            let healthAngle = health * TAU
            first = true
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    CGContextMoveToPoint(context, point.x, point.y)
                    first = false
                }
                else {
                    CGContextAddLineToPoint(context, point.x, point.y)
                }

                if angle + angleDelta > healthAngle {
                    let healthPoint = CGPoint(r: radius, a: angle + angleDelta)
                    let interPoint = CGPoint(
                        x: interpolate(healthAngle - angle, from: (0, angleDelta), to: (point.x, healthPoint.x)),
                        y: interpolate(healthAngle - angle, from: (0, angleDelta), to: (point.y, healthPoint.y))
                        )
                    CGContextAddLineToPoint(context, interPoint.x, interPoint.y)
                    CGContextAddLineToPoint(context, 0, 0)
                    break
                }
            }
            CGContextClosePath(context)
            CGContextDrawPath(context, .Fill)
        }
        CGContextRestoreGState(context)

        CGContextSetFillColorWithColor(context, turretColor.CGColor)
        CGContextSetLineWidth(context, 2)
        switch upgrade {
        case .Five:  fallthrough
        case .Four:  fallthrough
        case .Three: fallthrough
        case .Two:   fallthrough
        case .One:
            CGContextAddRect(context, CGRect(x: -2, y: -2, width: size.width / 2 + 2, height: 4))
            CGContextDrawPath(context, .Fill)
        }
    }

}
