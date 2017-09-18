////
///  GuardArtist.swift
//

var GuardBaseColor = 0x983C10
let GuardUpgradeColor = 0x85433A
var GuardStrokeColor = 0x983C10
var GuardRadar1Color = 0x7A401E
var GuardRadar2Color = 0x756151
var GuardTurretFillColor = 0x9F5926
var GuardTurretStrokeColor = 0xB8AF8F

class GuardArtist: PolygonArtist {
    var movementUpgrade: HasUpgrade
    var bulletUpgrade: HasUpgrade
    var radarUpgrade: HasUpgrade

    required init(_ movementUpgrade: HasUpgrade, _ bulletUpgrade: HasUpgrade, _ radarUpgrade: HasUpgrade, health: CGFloat) {
        self.movementUpgrade = movementUpgrade
        self.bulletUpgrade = bulletUpgrade
        self.radarUpgrade = radarUpgrade
        super.init(pointCount: 7, health: health)

        strokeColor = UIColor(hex: GuardStrokeColor)
        fillColor = UIColor(hex: radarUpgrade.shotgunBaseColor)
        if movementUpgrade.boolValue {
            size = CGSize(34)
        }
    }

    required init(pointCount: Int, health: CGFloat) {
        fatalError("init(pointCount:hasUpgrade:health:) has not been implemented")
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func generatePoints() -> [(CGFloat, CGFloat)] {
        let points = super.generatePoints()
        if movementUpgrade == .false {
            return points
        }

        let tinyDelta = 2.degrees
        let bigRadius: CGFloat = size.width / 2
        let smallRadius = bigRadius - 2
        return points.flatMap { angle, radius in
            return [
                (angle - tinyDelta, smallRadius),
                (angle - tinyDelta, bigRadius),
                (angle + tinyDelta, bigRadius),
                (angle + tinyDelta, smallRadius),
            ]
        }
    }

    override func draw(in context: CGContext) {
        super.draw(in: context)

        if radarUpgrade.boolValue {
            drawRadar(in: context)
        }

        if bulletUpgrade.boolValue {
            context.setStrokeColor(UIColor.gray.cgColor)
            let radius = size.width / 2 - 2
            let side = 2 * radius * sin(TAU_2 / CGFloat(pointCount))
            let angleDelta = TAU / CGFloat(pointCount)
            for i in 0..<pointCount {
                let angle = angleDelta * CGFloat(i)
                let angle1 = angle + TAU_2 + angleDelta
                let angle2 = angle + TAU_2 - angleDelta
                let start = CGPoint(r: radius, a: angle - angleDelta/2)
                let center = CGPoint(r: radius, a: angle)
                context.move(to: middle + start)
                context.addArc(
                    center: middle + center,
                    radius: side / 2,
                    startAngle: angle1, endAngle: angle2,
                    clockwise: true)
                context.drawPath(using: .stroke)
            }
        }
    }

    func drawRadar(in context: CGContext) {
        context.addEllipse(in: CGRect(center: middle, size: size))
        context.drawPath(using: .stroke)
    }
}

class GuardTurretArtist: Artist {
    let hasUpgrade: Bool
    let fillColor = UIColor(hex: GuardTurretFillColor)
    let strokeColor = UIColor(hex: GuardTurretStrokeColor)

    required init(hasUpgrade: Bool) {
        self.hasUpgrade = hasUpgrade
        super.init()
        size = CGSize(20)
        shadowed = .true
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.setShadow(offset: .zero, blur: shadowed.floatValue, color: fillColor.cgColor)

        // context.addEllipse(in: CGRect(size: size))
        // context.drawPath(using: .stroke)

        let circleCount = 3
        let dTheta = TAU / CGFloat(circleCount)
        let bigR = size.width / 4
        let smallR = bigR * cos(TAU_12)
        for index in 0..<circleCount {
            let theta = dTheta * CGFloat(index)
            let center = middle + CGPoint(r: bigR, a: theta)
            let size = CGSize(r: smallR)
            context.addEllipse(in: CGRect(center: center, size: size))
        }
        context.drawPath(using: .fillStroke)
    }
}
