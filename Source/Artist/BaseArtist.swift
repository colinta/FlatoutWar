//
//  BaseArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseArtist: Artist {
    var stroke = UIColor(hex: 0xFAA564)
    var fill = UIColor(hex: 0xEC942B)
    var upgrade: FiveUpgrades
    private let angles: [CGFloat]

    private var path: CGPath
    private var smallPath: CGPath

    required init(upgrade: FiveUpgrades, health: CGFloat) {
        self.upgrade = upgrade

        let pointCount: Int = 20
        var angles: [CGFloat] = [0]
        let angleDelta = TAU / CGFloat(pointCount)
        let angleRand = angleDelta / 2
        for i in 1..<pointCount {
            let angle = angleDelta * CGFloat(i) ± rand(angleRand)
            angles << angle
        }
        self.angles = angles

        self.path = CGPathCreateMutable()
        self.smallPath = CGPathCreateMutable()

        super.init()
        size = CGSize(40)
        generatePaths(health: health)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private func generatePaths(health health: CGFloat) {
        self.path = generatePath()
        if health == 1 {
            self.smallPath = generatePath()
        }
        else {
            self.smallPath = generatePath(max: health * TAU)
        }
    }

    private func generatePath(max max: CGFloat? = nil) -> CGPath {
        let path = CGPathCreateMutable()
        var first = true
        let r = size.width / 2
        for i in 0..<angles.count {
            let a = angles[i]
            if let max = max where a > max {
                break
            }

            let p = middle + CGPoint(r: r, a: TAU_2 + a)
            if first {
                CGPathMoveToPoint(path, nil, p.x, p.y)
                first = false
            }
            else {
                CGPathAddLineToPoint(path, nil, p.x, p.y)
            }
        }
        if let max = max {
            if first {
                CGPathMoveToPoint(path, nil, middle.x, middle.y)
            }

            let p = middle + CGPoint(r: r, a: TAU_2 + max)
            CGPathAddLineToPoint(path, nil, p.x, p.y)
            CGPathAddLineToPoint(path, nil, middle.x, middle.y)
        }
        CGPathCloseSubpath(path)
        return path
    }

    override func draw(context: CGContext) {
        CGContextSetAlpha(context, 0.5)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, fill.CGColor)
        CGContextAddPath(context, smallPath)
        CGContextDrawPath(context, .FillStroke)

        CGContextSetAlpha(context, 0.5)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, .FillStroke)

        if upgrade > 1 {
            CGContextSetAlpha(context, 1)
            CGContextAddPath(context, path)
            CGContextClip(context)
            switch upgrade {
                case .Five:
                    CGContextAddEllipseInRect(context, middle.rectWithSize(size * 0.8))
                    CGContextAddEllipseInRect(context, middle.rectWithSize(size * 0.6))
                    CGContextAddEllipseInRect(context, middle.rectWithSize(size * 0.4))
                    CGContextAddEllipseInRect(context, middle.rectWithSize(size * 0.2))
                case .Four:
                    CGContextAddEllipseInRect(context, middle.rectWithSize(size * 0.75))
                    fallthrough
                case .Three:
                    CGContextMoveToPoint(context, 0, 0)
                    CGContextAddLineToPoint(context, size.width, size.height)
                    CGContextMoveToPoint(context, 0, size.height)
                    CGContextAddLineToPoint(context, size.width, 0)
                    fallthrough
                case .Two:
                    CGContextMoveToPoint(context, 0, middle.y)
                    CGContextAddLineToPoint(context, size.width, middle.y)
                    CGContextMoveToPoint(context, middle.x, 0)
                    CGContextAddLineToPoint(context, middle.x, size.height)
                default:
                    break
            }
            CGContextDrawPath(context, .Stroke)
        }
    }

}

class BaseExplosionArtist: Artist {
    var stroke = UIColor(hex: 0xFAA564)
    var fill = UIColor(hex: 0xEC942B)
    let angle: CGFloat
    let spread: CGFloat

    required init(angle: CGFloat, spread: CGFloat) {
        self.angle = angle
        self.spread = spread
        super.init()
        size = CGSize(40)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetAlpha(context, 0.5)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, fill.CGColor)

        let angle2 = angle + spread ± rand(2.degrees)
        let p1 = middle + CGPoint(r: size.width / 2, a: angle)
        let p2 = middle + CGPoint(r: size.width / 2, a: angle2)
        CGContextMoveToPoint(context, middle.x, middle.y)
        CGContextAddLineToPoint(context, p1.x, p1.y)
        CGContextAddLineToPoint(context, p2.x, p2.y)
        CGContextClosePath(context)
        CGContextDrawPath(context, .Fill)

        CGContextMoveToPoint(context, p1.x, p1.y)
        CGContextAddLineToPoint(context, p2.x, p2.y)
        CGContextDrawPath(context, .Stroke)
    }

}
