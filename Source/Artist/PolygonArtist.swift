////
///  PolygonArtist.swift
//

class PolygonArtist: Artist {
    var baseColor: UIColor!

    let hasUpgrade: Bool
    let health: CGFloat
    var points: [(CGFloat, CGPoint)] = []

    required init(pointCount: Int, hasUpgrade: Bool, health: CGFloat) {
        self.hasUpgrade = hasUpgrade
        self.health = health

        super.init()
        shadowed = .True
        size = CGSize(35)

        let initialAngle: CGFloat
        if hasUpgrade {
            initialAngle = TAU / CGFloat(pointCount) / 2
        }
        else {
            initialAngle = 0
        }

        let angleDelta = TAU / CGFloat(pointCount)
        let radius: CGFloat = size.width / 2
        let smallRadius: CGFloat
        switch pointCount {
        case 5:
            smallRadius = radius * 0.75
        case 6:
            smallRadius = radius * 0.8
        default:
            smallRadius = radius * 0.85
        }

        for i in 0..<pointCount {
            let angle = initialAngle + angleDelta * CGFloat(i)
            let point = CGPoint(r: radius, a: angle)
            points << (angle, point)

            if hasUpgrade {
                let a2 = angle + angleDelta / 2
                let p2 = CGPoint(r: smallRadius, a: a2)
                points << (a2, p2)
            }
        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset() -> CGPoint {
        var offset = super.drawingOffset()
        offset += CGPoint(x: 1.5, y: 1.5)
        return offset
    }

    private func draw(points: [(CGFloat, CGPoint)], in context: CGContext, upTo healthAngle: CGFloat? = nil) {
        let radius: CGFloat = size.width / 2
        var first = true
        let angleDelta = TAU / CGFloat(points.count)
        for (angle, point) in points {
            if first {
                context.move(to: point)
                first = false
            }
            else {
                context.addLine(to: point)
            }

            if let healthAngle = healthAngle, angle + angleDelta > healthAngle {
                let healthPoint = CGPoint(r: radius, a: angle + angleDelta)
                let interPoint = CGPoint(
                    x: interpolate(healthAngle - angle, from: (0, angleDelta), to: (point.x, healthPoint.x)),
                    y: interpolate(healthAngle - angle, from: (0, angleDelta), to: (point.y, healthPoint.y))
                )
                context.addLine(to: interPoint)
                context.addLine(to: .zero)
                break
            }
        }
        context.closePath()
        context.drawPath(using: .fill)
    }

    override func draw(in context: CGContext) {
        context.setShadow(offset: .zero, blur: 5, color: baseColor.cgColor)
        context.setFillColor(baseColor.cgColor)
        context.translateBy(x: middle.x, y: middle.y)

        if health < 1 {
            context.setAlpha(0.5)
            draw(points: points, in: context)
            context.setAlpha(1)
            let healthAngle = health * TAU
            draw(points: points, in: context, upTo: healthAngle)
        }
        else {
            draw(points: points, in: context)
        }
    }

}
