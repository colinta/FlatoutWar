////
///  TurretArtist.swift
//

class TurretArtist: Artist {
    var baseColor = UIColor(hex: 0xFFEC24)
    var turretColor = UIColor(hex: 0xCDA715)
    var upgrade: HasUpgrade = .False
    var health: CGFloat

    required init(upgrade: HasUpgrade, health: CGFloat) {
        self.upgrade = upgrade
        self.health = health

        super.init()
        shadowed = .True
        size = CGSize(25)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset() -> CGPoint {
        var offset = super.drawingOffset()
        offset += CGPoint(x: 1.5, y: 1.5)
        return offset
    }

    override func draw(in context: CGContext) {
        context.setShadow(offset: .zero, blur: 5, color: baseColor.cgColor)
        context.setFillColor(baseColor.cgColor)
        context.translateBy(x: middle.x, y: middle.y)

        context.saveGState()
        context.scaleBy(x: 0.9, y: 0.9)
        let pointCount = 5 + (upgrade.boolValue ? 3 : 0)
        let angleDelta = TAU / CGFloat(pointCount)
        let radius = size.width / 2
        var first = true
        if health == 1 {
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    context.move(to: point)
                    first = false
                }
                else {
                    context.addLine(to: point)
                }
            }
            context.closePath()
            context.drawPath(using: .fill)
        }
        else {
            context.setAlpha(0.5)
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    context.move(to: point)
                    first = false
                }
                else {
                    context.addLine(to: point)
                }
            }
            context.closePath()
            context.drawPath(using: .fill)

            context.setAlpha(1)
            let healthAngle = health * TAU
            first = true
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let point = CGPoint(r: radius, a: angle)
                if first {
                    context.move(to: point)
                    first = false
                }
                else {
                    context.addLine(to: point)
                }

                if angle + angleDelta > healthAngle {
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
        context.restoreGState()

        context.setFillColor(turretColor.cgColor)
        context.setLineWidth(2)
        context.addRect(CGRect(x: -2, y: -2, width: size.width / 2 + 2, height: 4))
        context.drawPath(using: .fill)
    }

}
