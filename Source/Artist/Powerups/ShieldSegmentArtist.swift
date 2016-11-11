////
///  ShieldSegmentArtist.swift
//

class ShieldSegmentArtist: PowerupArtist {
    var color = UIColor(hex: PowerupRed)
    var health: CGFloat = 1

    required init() {
        super.init()
        size = CGSize(width: 5, height: 25)
    }

    override func draw(in context: CGContext) {
        super.draw(in: context)

        let segmentCount = 15
        let arc = TAU / CGFloat(segmentCount)
        let outerRadius: CGFloat = 60
        let outerWidth: CGFloat = 3
        let innerRadius = outerRadius - outerWidth

        context.translateBy(x: -55, y: middle.y)
        context.setAlpha(health)

        let angle: CGFloat = -arc / 2
        let start = CGPoint(r: innerRadius, a: angle)
        context.move(to: start)
        context.addArc(center: CGPoint(0, 0), radius: outerRadius, startAngle: angle, endAngle: angle + arc, clockwise: false)
        context.addArc(center: CGPoint(0, 0), radius: innerRadius, startAngle: angle + arc, endAngle: angle, clockwise: true)
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

}
