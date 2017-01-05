////
///  PolygonArtist.swift
//

class PolygonArtist: Artist {
    var strokeColor: UIColor!
    var fillColor: UIColor!

    let health: CGFloat
    let pointCount: Int

    required init(pointCount: Int, health: CGFloat) {
        self.health = health
        self.pointCount = pointCount

        super.init()
        shadowed = .True
        size = CGSize(30)
    }

    func generatePoints() -> [(CGFloat, CGFloat)] {
        var points: [(CGFloat, CGFloat)] = []
        let angleDelta = TAU / CGFloat(pointCount)
        let radius = size.width / 2
        for i in 0..<pointCount {
            let angle = angleDelta * CGFloat(i)
            points << (angle, radius)
        }
        return points
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset() -> CGPoint {
        var offset = super.drawingOffset()
        offset += CGPoint(x: 1.5, y: 1.5)
        return offset
    }

    func path(points: [(CGFloat, CGFloat)], upTo healthAngle: CGFloat?) -> CGPath {
        var first = true
        var prevAngle: CGFloat!
        var prevPoint: CGPoint!
        var firstPoint: CGPoint!

        let path = CGMutablePath()

        let drawInterpolated: (CGFloat, CGPoint, CGFloat) -> Void = { (angle, point, healthAngle) in
            let angleDelta = angle - prevAngle
            let interPoint = CGPoint(
                x: interpolate(healthAngle - prevAngle, from: (0, angleDelta), to: (prevPoint.x, point.x)),
                y: interpolate(healthAngle - prevAngle, from: (0, angleDelta), to: (prevPoint.y, point.y))
            )
            path.addLine(to: interPoint)
            path.addLine(to: .zero)
        }

        for (angle, radius) in points {
            let point = CGPoint(r: radius, a: angle)
            if first {
                path.move(to: point)
                firstPoint = point
                first = false
            }
            else {
                if let healthAngle = healthAngle,
                    angle > healthAngle
                {
                    drawInterpolated(angle, point, healthAngle)
                    break
                }

                path.addLine(to: point)
            }

            prevPoint = point
            prevAngle = angle
        }

        if let healthAngle = healthAngle {
            drawInterpolated(TAU, firstPoint, healthAngle)
        }

        path.closeSubpath()
        return path
    }

    func draw(points: [(CGFloat, CGFloat)], in context: CGContext, upTo healthAngle: CGFloat? = nil) {
        let path = self.path(points: points, upTo: healthAngle)

        context.addPath(path)
        if healthAngle == nil {
            context.drawPath(using: .stroke)
        }
        else {
            context.drawPath(using: .fill)
        }
    }

    override func draw(in context: CGContext) {
        context.setShadow(offset: .zero, blur: 5, color: fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.setFillColor(fillColor.cgColor)

        context.saveGState()
        context.translateBy(x: middle.x, y: middle.y)
        let healthAngle = health * TAU
        let points = generatePoints()
        draw(points: points, in: context, upTo: healthAngle)
        draw(points: points, in: context)
        context.restoreGState()
    }

}
