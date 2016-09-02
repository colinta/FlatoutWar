////
///  DroneArtist.swift
//

let DroneColor = 0x25B1FF
let DroneUpgradeColor = 0x6CFFF1

class DroneArtist: Artist {
    var stroke: UIColor
    var speedUpgrade: HasUpgrade
    var radarUpgrade: HasUpgrade
    var bulletUpgrade: HasUpgrade
    var health: CGFloat

    private let strokeWidth: CGFloat = 2
    private let innerRadius: CGFloat = 1.5
    private let ellipseDiameter: CGFloat = 1.5 * 8
    private var transitionHealth: CGFloat = 0.6

    required init(speedUpgrade: HasUpgrade, radarUpgrade: HasUpgrade, bulletUpgrade: HasUpgrade, health: CGFloat) {
        self.speedUpgrade = speedUpgrade
        self.radarUpgrade = radarUpgrade
        self.bulletUpgrade = bulletUpgrade
        self.health = health
        self.stroke = UIColor(hex: bulletUpgrade ? DroneUpgradeColor : DroneColor)

        super.init()
        shadowed = .True
        size = CGSize(20)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func drawingOffset() -> CGPoint {
        var offset = super.drawingOffset()

        if speedUpgrade {
            offset += CGPoint(x: 1.5, y: 1.5)
        }

        return offset
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, strokeWidth)
        CGContextSetShadowWithColor(context, .zero, 5, stroke.CGColor)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)

        if radarUpgrade {
            drawRadar(context)
        }

        if speedUpgrade {
            drawFastDrone(context)
        }
        else {
            drawRegularDrone(context)
        }
    }

    private func drawRadar(context: CGContext) {
        if health == 1 {
            CGContextAddEllipseInRect(context, middle.rect(size: CGSize(ellipseDiameter)))
            CGContextDrawPath(context, .Stroke)
        }
        else {
            CGContextSetAlpha(context, 0.5)
            CGContextAddEllipseInRect(context, middle.rect(size: CGSize(ellipseDiameter)))
            CGContextDrawPath(context, .Stroke)

            CGContextSetAlpha(context, 1)
            let startAngle = -TAU_3_8 + interpolate(health, from: (1, 0), to: (0, TAU_2))
            let endAngle = -TAU_3_8 + TAU - interpolate(health, from: (1, 0), to: (0, TAU_2))
            CGContextAddArc(context, middle.x, middle.y, ellipseDiameter / 2,
                startAngle, endAngle, 0)
            CGContextDrawPath(context, .Stroke)
        }
    }

    private func drawRegularDrone(context: CGContext) {
        if health == 1 {
            CGContextMoveToPoint(context, middle.x, 0)
            CGContextAddLineToPoint(context, middle.x, size.height)
            CGContextMoveToPoint(context, 0, middle.y)
            CGContextAddLineToPoint(context, size.width, middle.y)
            CGContextDrawPath(context, .Stroke)
        }
        else {
            CGContextSetAlpha(context, 0.5)
            CGContextMoveToPoint(context, middle.x, 0)
            CGContextAddLineToPoint(context, middle.x, size.height)
            CGContextMoveToPoint(context, 0, middle.y)
            CGContextAddLineToPoint(context, size.width, middle.y)
            CGContextDrawPath(context, .Stroke)

            CGContextSetAlpha(context, 1)
            CGContextMoveToPoint(context, (1 - health) * size.width, middle.y)
            CGContextAddLineToPoint(context, size.width, middle.y)
            CGContextMoveToPoint(context, middle.x, (1 - health) * size.height)
            CGContextAddLineToPoint(context, middle.x, size.height)
            CGContextDrawPath(context, .Stroke)
        }
    }

    private func drawFastDrone(context: CGContext) {
        if health == 1 {
            CGContextMoveToPoint(context, 0, middle.y - innerRadius)
            CGContextAddLineToPoint(context, 0, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y - innerRadius)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Stroke)
        }
        else {
            CGContextSetAlpha(context, 0.5)
            CGContextMoveToPoint(context, 0, middle.y - innerRadius)
            CGContextAddLineToPoint(context, 0, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y - innerRadius)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Stroke)
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
                CGContextAddRect(context, CGRect(
                    x: clipPoint.x, y: transitionPoint.y,
                    width: clipSize.width, height: transitionSize.height
                    ))
                CGContextAddRect(context, CGRect(
                    x: transitionPoint.x, y: clipPoint.y,
                    width: transitionSize.width, height: clipSize.height
                    ))
                CGContextClip(context)
            }
            else {
                CGContextClipToRect(context, CGRect(origin: clipPoint, size: clipSize))
            }
            CGContextSetAlpha(context, 1)
            CGContextMoveToPoint(context, 0, middle.y - innerRadius)
            CGContextAddLineToPoint(context, 0, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, middle.x - innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, size.height)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y + innerRadius)
            CGContextAddLineToPoint(context, size.width, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, middle.y - innerRadius)
            CGContextAddLineToPoint(context, middle.x + innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, 0)
            CGContextAddLineToPoint(context, middle.x - innerRadius, middle.y - innerRadius)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Stroke)
        }
    }

}
