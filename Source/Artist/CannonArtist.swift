////
///  CannonArtist.swift
//

var CannonBaseColor = 0xFFF71D
var CannonTurretFillColor = 0xFEC809
var CannonTurretStrokeColor = 0xC2B98F

class CannonArtist: Artist {
    var upgrade: HasUpgrade = .False
    var health: CGFloat
    var angles: [CGFloat] = []

    required init(upgrade: HasUpgrade, health: CGFloat) {
        self.upgrade = upgrade
        self.health = health

        super.init()
        shadowed = .True
        size = CGSize(35)

        let initialAngle: CGFloat
        let pointCount = 5
        if upgrade.boolValue {
            initialAngle = TAU / CGFloat(pointCount) / 2
        }
        else {
            initialAngle = 0
        }

        let angleDelta = TAU / CGFloat(pointCount)
        for i in 0..<pointCount {
            let angle = initialAngle + angleDelta * CGFloat(i)
            angles << angle
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

    private func draw(angles: [CGFloat], in context: CGContext, upTo healthAngle: CGFloat? = nil) {
        let radius: CGFloat = size.width / 2
        var first = true
        let angleDelta = TAU / CGFloat(angles.count)
        for angle in angles {
            let point = CGPoint(r: radius, a: angle)
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
        context.setShadow(offset: .zero, blur: 5, color: UIColor(hex: CannonBaseColor).cgColor)
        context.setFillColor(UIColor(hex: CannonBaseColor).cgColor)
        context.translateBy(x: middle.x, y: middle.y)

        if health < 1 {
            context.setAlpha(0.5)
            draw(angles: angles, in: context)
            context.setAlpha(1)
            let healthAngle = health * TAU
            draw(angles: angles, in: context, upTo: healthAngle)
        }
        else {
            draw(angles: angles, in: context)
        }
    }

}

class CannonBoxArtist: RectArtist {
    required init(_ size: CGSize, _ color: UIColor) {
        super.init(size, color)
        self.fillColor = color
        self.strokeColor = color
        self.size = size
    }

    override func draw(in context: CGContext) {
        self.setup(in: context)

        let r: CGFloat = 5
        context.move(to: CGPoint(0, size.height - r))
        context.addLine(to: CGPoint(r, size.height))
        context.addLine(to: CGPoint(size.width, size.height))
        context.addLine(to: CGPoint(size.width, 0))
        context.addLine(to: CGPoint(r, 0))
        context.addLine(to: CGPoint(0, r))
        context.closePath()

        context.drawPath(using: drawingMode)
    }
}
