////
///  ShieldPowerupArtist.swift
//

class ShieldPowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let segmentCount = 15
        let arc = TAU / CGFloat(segmentCount)
        let outerRadius = size.width / 2
        let outerWidth: CGFloat = 3
        let innerRadius = outerRadius - outerWidth

        context.addEllipse(in: CGRect(center: middle, size: CGSize(r: innerRadius)))
        context.drawPath(using: .fill)

        context.translateBy(x: middle.x, y: middle.y)
        var angle: CGFloat = arc / 2
        segmentCount.times {
            let start = CGPoint(r: innerRadius, a: angle)
            context.move(to: start)
            context.addArc(center: CGPoint(0, 0), radius: outerRadius, startAngle: angle, endAngle: angle + arc, clockwise: false)
            context.addArc(center: CGPoint(0, 0), radius: innerRadius, startAngle: angle + arc, endAngle: angle, clockwise: true)
            context.closePath()
            context.drawPath(using: .fillStroke)
            angle += arc
        }
    }

}
