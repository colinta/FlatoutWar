////
///  MinesPowerupArtist.swift
//

class MinesPowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let outerRadius = size.width / 2 - 3
        let innerRadius = outerRadius - 2
        let segmentCount = 8
        let smallArc: CGFloat = 10.degrees
        let arc = TAU / CGFloat(segmentCount)

        context.translateBy(x: middle.x, y: middle.y)
        var angle: CGFloat = -smallArc / 2
        var first = true
        segmentCount.times {
            let p1 = CGPoint(r: innerRadius, a: angle)
            let p2 = CGPoint(r: outerRadius, a: angle)
            let p3 = CGPoint(r: outerRadius, a: angle + smallArc)
            let p4 = CGPoint(r: innerRadius, a: angle + smallArc)
            if first {
                context.move(to: p1)
            }
            else {
                context.addLine(to: p1)
            }
            context.addLine(to: p2)
            context.addLine(to: p3)
            context.addLine(to: p4)
            angle += arc
            first = false
        }
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

}
