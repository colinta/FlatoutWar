////
///  DroneArtist.swift
//

let DroneColor = 0x25B1FF
let DroneUpgradeColor = 0x6CFFF1

class DroneArtist: Artist {
    var stroke: UIColor
    var movementUpgrade: HasUpgrade
    var bulletUpgrade: HasUpgrade
    var radarUpgrade: HasUpgrade
    var health: CGFloat

    private let strokeWidth: CGFloat = 2
    private let innerRadius: CGFloat = 1.5
    private let ellipseDiameter: CGFloat = 1.5 * 8
    private var transitionHealth: CGFloat = 0.6

    required init(_ movementUpgrade: HasUpgrade, _ bulletUpgrade: HasUpgrade, _ radarUpgrade: HasUpgrade, health: CGFloat) {
        self.movementUpgrade = movementUpgrade
        self.bulletUpgrade = bulletUpgrade
        self.radarUpgrade = radarUpgrade
        self.health = health
        self.stroke = UIColor(hex: movementUpgrade.boolValue ? DroneUpgradeColor : DroneColor)

        super.init()
        shadowed = .true
        size = CGSize(20)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset() -> CGPoint {
        var offset = super.drawingOffset()

        if bulletUpgrade.boolValue {
            offset += CGPoint(x: 1.5, y: 1.5)
        }

        return offset
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(strokeWidth)
        context.setShadow(offset: .zero, blur: 5, color: stroke.cgColor)
        context.setStrokeColor(stroke.cgColor)

        if radarUpgrade.boolValue {
            drawRadar(context)
        }

        if bulletUpgrade.boolValue {
            drawFastDrone(context)
        }
        else {
            drawRegularDrone(context)
        }
    }

    private func drawRadar(_ context: CGContext) {
        if health == 1 {
            context.addEllipse(in: CGRect(center: middle, size: CGSize(ellipseDiameter)))
            context.drawPath(using: .stroke)
        }
        else {
            context.setAlpha(0.5)
            context.addEllipse(in: CGRect(center: middle, size: CGSize(ellipseDiameter)))
            context.drawPath(using: .stroke)

            context.setAlpha(1)
            let startAngle = -TAU_3_8 + interpolate(health, from: (1, 0), to: (0, TAU_2))
            let endAngle = -TAU_3_8 + TAU - interpolate(health, from: (1, 0), to: (0, TAU_2))
            context.addArc(center: CGPoint(middle.x, middle.y), radius: ellipseDiameter / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.drawPath(using: .stroke)
        }
    }

    private func drawRegularDrone(_ context: CGContext) {
        if health == 1 {
            context.move(to: CGPoint(x: middle.x, y: 0))
            context.addLine(to: CGPoint(x: middle.x, y: size.height))
            context.move(to: CGPoint(x: 0, y: middle.y))
            context.addLine(to: CGPoint(x: size.width, y: middle.y))
            context.drawPath(using: .stroke)
        }
        else {
            context.setAlpha(0.5)
            context.move(to: CGPoint(x: middle.x, y: 0))
            context.addLine(to: CGPoint(x: middle.x, y: size.height))
            context.move(to: CGPoint(x: 0, y: middle.y))
            context.addLine(to: CGPoint(x: size.width, y: middle.y))
            context.drawPath(using: .stroke)

            context.setAlpha(1)
            context.move(to: CGPoint(x: (1 - health) * size.width, y: middle.y))
            context.addLine(to: CGPoint(x: size.width, y: middle.y))
            context.move(to: CGPoint(x: middle.x, y: (1 - health) * size.height))
            context.addLine(to: CGPoint(x: middle.x, y: size.height))
            context.drawPath(using: .stroke)
        }
    }

    private func drawFastDrone(_ context: CGContext) {
        if health == 1 {
            context.move(to: CGPoint(x: 0, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: 0, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y - innerRadius))
            context.closePath()
            context.drawPath(using: .stroke)
        }
        else {
            context.setAlpha(0.5)
            context.move(to: CGPoint(x: 0, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: 0, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y - innerRadius))
            context.closePath()
            context.drawPath(using: .stroke)
            if health == 0 {
                return
            }

            let shadowSize = CGSize(5)
            let offset = CGPoint(1, 1)
            let adjSize = size + CGSize(2)
            let clipSize = health * adjSize + shadowSize
            let clipPoint = CGPoint((1 - health) * adjSize.width, (1 - health) * adjSize.height) - offset
            if health < transitionHealth {
                let transitionPoint = CGPoint((1 - transitionHealth) * adjSize.width, (1 - transitionHealth) * adjSize.height) - offset
                let transitionSize = transitionHealth * adjSize + shadowSize
                context.addRect(CGRect(
                    x: clipPoint.x, y: transitionPoint.y,
                    width: clipSize.width, height: transitionSize.height
                    ))
                context.addRect(CGRect(
                    x: transitionPoint.x, y: clipPoint.y,
                    width: transitionSize.width, height: clipSize.height
                    ))
                context.clip()
            }
            else {
                context.clip(to: CGRect(origin: clipPoint, size: clipSize))
            }
            context.setAlpha(1)
            context.move(to: CGPoint(x: 0, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: 0, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: size.height))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y + innerRadius))
            context.addLine(to: CGPoint(x: size.width, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: middle.y - innerRadius))
            context.addLine(to: CGPoint(x: middle.x + innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: 0))
            context.addLine(to: CGPoint(x: middle.x - innerRadius, y: middle.y - innerRadius))
            context.closePath()
            context.drawPath(using: .stroke)
        }
    }

}
