////
///  WarningArtist.swift
//

class WarningArtist: Artist {
    let fill = UIColor(hex: 0xFFFB28)
    let stroke = UIColor(hex: 0xD2081B)

    required init() {
        super.init()
        size = CGSize(10)
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(1)
        context.setFillColor(fill.cgColor)
        context.setStrokeColor(stroke.cgColor)

        let radius: CGFloat = 2
        let triRadius: CGFloat = size.height / 2 - radius

        let center = middle + CGPoint(y: radius / 2)
        let a = center + CGPoint(r: triRadius, a: TAU_3_4)
        let b = center + CGPoint(r: triRadius, a: TAU_12)
        let c = center + CGPoint(r: triRadius, a: 5 * TAU_12)

        let A = Segment(
            p1: a + CGPoint(r: 2 * radius, a: TAU_3_4),
            p2: a + CGPoint(r: radius, a: 11 * TAU_12)
            )
        let B = Segment(
            p1: b + CGPoint(r: 2 * radius, a: TAU_12),
            p2: b + CGPoint(r: radius, a: 3 * TAU_12)
            )
        let C = Segment(
            p1: c + CGPoint(r: 2 * radius, a: 5 * TAU_12),
            p2: c + CGPoint(r: radius, a: 7 * TAU_12)
            )
        context.move(to: C.p2)
        context.addArc(tangent1End: A.p1, tangent2End: A.p2, radius: radius)
        context.addArc(tangent1End: B.p1, tangent2End: B.p2, radius: radius)
        context.addArc(tangent1End: C.p1, tangent2End: C.p2, radius: radius)
        context.closePath()
        context.drawPath(using: .fill)

        let exHeight: CGFloat = 7
        let exDotHeight: CGFloat = 1
        let exOffset = exDotHeight / 2
        context.translateBy(x: 0, y: -exOffset)
        context.move(to: CGPoint(x: center.x, y: center.y - exHeight / 2 ))
        context.addLine(to: CGPoint(x: center.x, y: center.y + exHeight / 2 - 2 * exDotHeight ))
        context.move(to: CGPoint(x: center.x, y: center.y + exHeight / 2 - exDotHeight ))
        context.addLine(to: CGPoint(x: center.x, y: center.y + exHeight / 2 ))
        context.drawPath(using: .stroke)
    }

}
