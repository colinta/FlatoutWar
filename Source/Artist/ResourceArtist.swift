////
///  ResourceArtist.swift
//

let ResourceBlue = 0x1158D9

class ResourceArtist: Artist {
    let remaining: CGFloat
    var color = UIColor(hex: ResourceBlue)

    required init(amount: CGFloat, remaining: CGFloat) {
        self.remaining = remaining
        super.init()
        size = CGSize(amount)
    }

    required convenience init() {
        self.init(amount: 30, remaining: 1)
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        let spokeRemaining = interpolate(remaining, from: (0, 1), to: (0.5, 1))
        let minBallSize: CGFloat = 1.5
        let spokeSize = max(size.width / 10 * spokeRemaining, minBallSize)
        let outerRadius = size.width / 2 - spokeSize
        let angles: [CGFloat] = [-TAU_4, TAU_12, 5 * TAU_12]
        var spokes: [CGPoint] = []
        for angle in angles {
            let pt = middle + CGPoint(r: outerRadius, a: angle)
            CGContextAddEllipseInRect(context, pt.rect(radius: spokeSize))
            spokes << pt
        }

        let innerRadius = outerRadius * remaining
        if innerRadius > 0 {
            CGContextAddEllipseInRect(context, middle.rect(radius: max(innerRadius, minBallSize)))
        }
        CGContextDrawPath(context, .Fill)

        var first = true
        for pt in spokes {
            if first {
                CGContextMoveToPoint(context, pt.x, pt.y)
            }
            else {
                CGContextAddLineToPoint(context, pt.x, pt.y)
            }
            first = false
        }
        CGContextClosePath(context)
        CGContextDrawPath(context, .Stroke)
    }

    func v1(context: CGContext) {
        let spokeSize: CGFloat = 5
        let outerRadius: CGFloat = size.width / 2 - spokeSize / 2
        let innerRadius: CGFloat = outerRadius - spokeSize
        let smallRadius: CGFloat = innerRadius - 3
        let angles: [CGFloat] = [-TAU_4, TAU_12, 5 * TAU_12]
        var first = true
        for angle in angles {
            let p0 = CGPoint(r: innerRadius, a: angle)
            let p1 = CGPoint(r: outerRadius, a: angle)
            let pts: [CGPoint] = [
                p0 + CGPoint(r: spokeSize / 2, a: angle - TAU_4),
                p1 + CGPoint(r: spokeSize / 2, a: angle - TAU_4),
                p1 + CGPoint(r: spokeSize / 2, a: angle + TAU_4),
                p0 + CGPoint(r: spokeSize / 2, a: angle + TAU_4),
            ]
            for pt in pts {
                if first {
                    CGContextMoveToPoint(context, middle.x + pt.x, middle.y + pt.y)
                }
                else {
                    CGContextAddLineToPoint(context, middle.x + pt.x, middle.y + pt.y)
                }
                first = false
            }
        }
        CGContextClosePath(context)

        first = true
        for angle in angles {
            let pt = CGPoint(r: smallRadius, a: angle)
            if first {
                CGContextMoveToPoint(context, middle.x + pt.x, middle.y + pt.y)
            }
            else {
                CGContextAddLineToPoint(context, middle.x + pt.x, middle.y + pt.y)
            }
            first = false
        }
        CGContextClosePath(context)

        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextEOFillPath(context)
    }

}
