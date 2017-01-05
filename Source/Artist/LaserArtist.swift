////
///  LaserNodeArtist.swift
//

var LaserBaseColor = 0x185BFF
var LaserRadarColor = 0x236AFE
var LaserTurretFillColor = 0x236AFE
var LaserTurretStrokeColor = 0x7A93C0

class LaserNodeArtist: PolygonArtist {
    required init(hasUpgrade: Bool, health: CGFloat) {
        super.init(pointCount: 3, health: health)

        fillColor = UIColor(hex: LaserBaseColor)
        strokeColor = UIColor(hex: LaserBaseColor)
    }

    required init(pointCount: Int, health: CGFloat) {
        fatalError("init(pointCount:hasUpgrade:health:) has not been implemented")
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

class LaserTurretArtist: Artist {
    let hasUpgrade: Bool
    let isFiring: Bool
    let fillColor = UIColor(hex: LaserTurretFillColor)
    let strokeColor = UIColor(hex: LaserTurretStrokeColor)

    required init(hasUpgrade: Bool, isFiring: Bool) {
        self.hasUpgrade = hasUpgrade
        self.isFiring = isFiring
        super.init()
        size = CGSize(20)
        shadowed = .True
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.setShadow(offset: .zero, blur: shadowed.floatValue, color: fillColor.cgColor)

        let focalR: CGFloat = 2.5
        let outerR: CGFloat = size.width - focalR
        let mirrorWidth: CGFloat = 3
        let innerR: CGFloat = outerR - mirrorWidth
        let theta = asin(size.height / 2 / outerR)

        // Origin is in the center of the focal circle
        context.translateBy(x: size.width - focalR, y: middle.y)

        if hasUpgrade {
            let focalSize = CGSize(focalR, 10)
            let focalRect = CGRect(center: .zero, size: focalSize)
            context.addRect(focalRect)
        }
        else {
            context.addEllipse(in: CGRect(center: .zero, size: CGSize(r: focalR)))
        }
        context.drawPath(using: .fillStroke)

        let smallerR = innerR - 2
        let dTheta = 3.degrees
        let a1 = TAU_2 - theta
        let a1a = a1 + dTheta
        let a1b = TAU_2 - dTheta
        let a2 = TAU_2 + theta
        let a2a = a2 - dTheta
        let a2b = TAU_2 + dTheta

        if isFiring {
            var firingAngles: [CGFloat] = [
                a1a,
                a2a
            ]
            if hasUpgrade {
                firingAngles << TAU_2
            }

            let firingR = (outerR + innerR) / 2
            for angle in firingAngles {
                let point = CGPoint(r: firingR, a: angle)
                context.move(to: point)
                context.addLine(to: .zero)
            }
            context.drawPath(using: .stroke)
        }

        if hasUpgrade {
            context.move(to: CGPoint(r: smallerR, a: a1))
            context.addLine(to: CGPoint(r: outerR, a: a1))
            context.addArc(center: .zero, radius: outerR, startAngle: a1, endAngle: a2, clockwise: false)
            context.addLine(to: CGPoint(r: smallerR, a: a2))
            context.addLine(to: CGPoint(r: innerR, a: a2a))
            context.addArc(center: .zero, radius: innerR, startAngle: a2a, endAngle: a2b, clockwise: true)
            context.addLine(to: CGPoint(r: smallerR, a: TAU_2))
            context.addLine(to: CGPoint(r: innerR, a: a1b))
            context.addArc(center: .zero, radius: innerR, startAngle: a1b, endAngle: a1a, clockwise: true)
            context.closePath()

        }
        else {
            context.move(to: CGPoint(r: innerR, a: a1))
            context.addLine(to: CGPoint(r: outerR, a: a1))
            context.addArc(center: .zero, radius: outerR, startAngle: a1, endAngle: a2, clockwise: false)
            context.addLine(to: CGPoint(r: innerR, a: a2))
            context.addArc(center: .zero, radius: innerR, startAngle: a2, endAngle: a1, clockwise: true)
            context.closePath()
        }
        context.drawPath(using: .fillStroke)
    }
}
