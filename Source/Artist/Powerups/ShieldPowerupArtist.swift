////
///  ShieldPowerupArtist.swift
//

class ShieldPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let segmentCount = 15
        let arc = TAU / CGFloat(segmentCount)
        let outerRadius = size.width / 2
        let outerWidth: CGFloat = 3
        let innerRadius = outerRadius - outerWidth

        CGContextAddEllipseInRect(context, middle.rect(size: CGSize(r: innerRadius)))
        CGContextDrawPath(context, .Fill)

        CGContextTranslateCTM(context, middle.x, middle.y)
        var angle: CGFloat = arc / 2
        segmentCount.times {
            let start = CGPoint(r: innerRadius, a: angle)
            CGContextMoveToPoint(context, start.x, start.y)
            CGContextAddArc(context, 0, 0, outerRadius, angle, angle + arc, 0)
            CGContextAddArc(context, 0, 0, innerRadius, angle + arc, angle, 1)
            CGContextClosePath(context)
            CGContextDrawPath(context, .FillStroke)
            angle += arc
        }
    }

}
