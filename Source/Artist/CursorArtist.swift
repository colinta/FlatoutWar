////
///  CursorArtist.swift
//

class CursorArtist: Artist {
    var color = UIColor(hex: 0x1158D9)

    required init() {
        super.init()
        size = CGSize(80)
    }

    override func draw(in context: CGContext) {
        let lineWidth: CGFloat = 2
        let radius = middle.x - lineWidth / 2
        let numArcs = 18
        for i in 0..<numArcs {
            let a1 = CGFloat(2 * i) * TAU_2 / CGFloat(numArcs)
            let a2 = CGFloat(2 * i + 1) * TAU_2 / CGFloat(numArcs)
            let pt = CGPoint(r: radius, a: a1)
            context.move(to: middle + pt)
            context.addArc(center: middle, radius: radius, startAngle: a1, endAngle: a2, clockwise: false)
        }
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.drawPath(using: .stroke)
    }

}
