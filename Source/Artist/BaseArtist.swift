////
///  BaseArtist.swift
//

private var savedAngles: [CGFloat]?

class BaseArtist: Artist {
    var stroke = UIColor(hex: 0xFAA564)
    var fill = UIColor(hex: 0xC6811D)
    var rotateUpgrade: HasUpgrade
    var bulletUpgrade: HasUpgrade
    var radarUpgrade: HasUpgrade
    var health: CGFloat

    private var path: CGPath
    private var smallPath: CGPath

    required init(rotateUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, health: CGFloat) {
        self.health = health
        self.rotateUpgrade = rotateUpgrade
        self.bulletUpgrade = bulletUpgrade
        self.radarUpgrade = radarUpgrade

        if savedAngles == nil {
            let pointCount: Int = 20
            var angles: [CGFloat] = []
            let angleDelta = TAU / CGFloat(pointCount)
            let angleRand = angleDelta / 2
            for i in 0..<pointCount {
                let angle: CGFloat
                if i == 0 {
                    angle = 0
                }
                else {
                    angle = angleDelta * CGFloat(i) ± rand(angleRand)
                }
                angles << angle
            }

            savedAngles = angles
        }

        self.path = CGMutablePath()
        self.smallPath = CGMutablePath()

        super.init()
        size = CGSize(40)
        generatePaths(health: health)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private func generatePaths(health: CGFloat) {
        self.path = generatePath()
        if health == 1 {
            self.smallPath = generatePath()
        }
        else {
            self.smallPath = generatePath(max: health * TAU)
        }
    }

    private func generatePath(max: CGFloat? = nil) -> CGPath {
        let path = CGMutablePath()
        var first = true
        let r = size.width / 2
        for a in savedAngles! {
            if let max = max, a > max {
                break
            }

            let p = middle + CGPoint(r: r, a: TAU_2 + a)
            if first {
                path.move(to: p)
                first = false
            }
            else {
                path.addLine(to: p)
            }
        }
        if let max = max {
            if first {
                path.move(to: middle)
            }

            let p = middle + CGPoint(r: r, a: TAU_2 + max)
            path.addLine(to: p)
            path.addLine(to: middle)
        }
        path.closeSubpath()
        return path
    }

    override func draw(in context: CGContext) {
        context.setAlpha(1)
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(fill.cgColor)
        context.addPath(smallPath)
        context.drawPath(using: .fillStroke)

        if health < 1 {
            context.setAlpha(0.5)
            context.addPath(path)
            context.drawPath(using: .fillStroke)
        }

        if rotateUpgrade.boolValue || bulletUpgrade.boolValue || radarUpgrade.boolValue {
            context.setAlpha(1)
            context.addPath(path)
            context.clip()

            if rotateUpgrade.boolValue {
                context.addEllipse(in: CGRect(center: middle, size: size * 0.8))
                context.addEllipse(in: CGRect(center: middle, size: size * 0.4))
            }

            if radarUpgrade.boolValue {
                context.addRect(CGRect(center: middle, size: size * 0.7))
                context.addRect(CGRect(center: middle, size: size * 0.6))
            }

            if bulletUpgrade.boolValue {
                context.move(to: .zero)
                context.addLine(to: CGPoint(x: size.width, y: size.height))
                context.move(to: CGPoint(x: 0, y: size.height))
                context.addLine(to: CGPoint(x: size.width, y: 0))
                context.move(to: CGPoint(x: 0, y: middle.y))
                context.addLine(to: CGPoint(x: size.width, y: middle.y))
                context.move(to: CGPoint(x: middle.x, y: 0))
                context.addLine(to: CGPoint(x: middle.x, y: size.height))
            }
            context.drawPath(using: .stroke)
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

    override func draw(in context: CGContext) {
        context.setAlpha(0.5)
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(fill.cgColor)

        let angle2 = angle + spread ± rand(2.degrees)
        let p1 = middle + CGPoint(r: size.width / 2, a: angle)
        let p2 = middle + CGPoint(r: size.width / 2, a: angle2)
        context.move(to: middle)
        context.addLine(to: p1)
        context.addLine(to: p2)
        context.closePath()
        context.drawPath(using: .fill)

        context.move(to: p1)
        context.addLine(to: p2)
        context.drawPath(using: .stroke)
    }

}
