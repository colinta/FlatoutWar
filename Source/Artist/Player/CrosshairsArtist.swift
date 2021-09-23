////
///  CrosshairsArtist.swift
//

class CrosshairsArtist: Artist {
    var color = UIColor(hex: 0x1158D9)

    required init(hasUpgrade: Bool) {
        super.init()
        size = CGSize(40)
        color = UIColor(hex: hasUpgrade ? BaseRadar2Color : BaseRadar1Color)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        let lineWidth: CGFloat = 2
        let littleRadius = middle.x - lineWidth / 2 - 5
        let bigRadius = middle.x - lineWidth / 2
        let numArcs = 4
        context.move(to: middle + CGPoint(x: littleRadius))
        for i in 0..<numArcs {
            let a1 = CGFloat(i) * TAU / CGFloat(numArcs)
            let a2 = CGFloat(i + 1) * TAU / CGFloat(numArcs)
            let innerPoint = CGPoint(r: littleRadius, a: a1)
            let outerPoint = CGPoint(r: bigRadius, a: a1)
            context.addLine(to: middle + outerPoint)
            context.addLine(to: middle + innerPoint)
            context.addArc(center: middle, radius: littleRadius, startAngle: a1, endAngle: a2, clockwise: false)
        }
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.drawPath(using: .stroke)
    }

}
