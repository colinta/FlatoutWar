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
    private let points: [CGPoint]

    private var path: CGPath
    private var smallPath: CGPath

    override var size: CGSize { didSet { generatePaths() } }
    var health = Float(1.0) { didSet { generatePaths() } }

    required init(upgrade: FiveUpgrades) {
        self.upgrade = upgrade

        let pointCount: Int = 20
        var angles = [CGFloat]()
        var points = [CGPoint]()
        let angleDelta = TAU / CGFloat(pointCount)
        let angleRand = angleDelta / 2
        for i in 0..<pointCount {
            let angle = angleDelta * CGFloat(i) ± rand(angleRand)
            angles << angle
            points << CGPoint(r: 1, a: angle + TAU_2)
        }
        self.angles = angles
        self.points = points

        self.path = CGPathCreateMutable()
        self.smallPath = CGPathCreateMutable()

        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private func generatePaths() {
        self.path = generatePath()
        self.smallPath = generatePath(max: CGFloat(round(health * 360.0) / 360.0) * TAU)
    }

    private func generatePath(max max: CGFloat? = nil) -> CGPath {
        let path = CGPathCreateMutable()
        var first = true
        for i in 0..<points.count {
            let a = angles[i]
            let p: CGPoint
            if let max = max where a > max {
                p = CGPoint(r: 1, a: max + TAU_2)
            }
            else {
                p = points[i]
            }
            let localPoint = (p * size + self.size) * 0.5

            if first {
                CGPathMoveToPoint(path, nil, localPoint.x, localPoint.y)
                first = false
            }
            else {
                CGPathAddLineToPoint(path, nil, localPoint.x, localPoint.y)
            }

            if let max = max where a > max {
                CGPathAddLineToPoint(path, nil, middle.x, middle.y)
            }
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
