////
///  HourglassPowerupArtist.swift
//

class HourglassPowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let bigR = size.width / 2 - 4
        let outerR = bigR - 3
        let glassR = bigR - 4
        let smallR = bigR - 10
        context.translateBy(x: middle.x, y: 0)
        context.move(to: CGPoint(x: -bigR, y: 0))
        context.addLine(to: CGPoint(x: -outerR, y: 0))
        context.addLine(to: CGPoint(x: -outerR, y: size.height))
        context.addLine(to: CGPoint(x: -outerR, y: 0))
        context.addLine(to: CGPoint(x: outerR, y: 0))
        context.addLine(to: CGPoint(x: outerR, y: size.height))
        context.addLine(to: CGPoint(x: outerR, y: 0))
        context.addLine(to: CGPoint(x: bigR, y: 0))
        context.addLine(to: CGPoint(x: glassR, y: 0))
        context.addCurve(
            to: CGPoint(smallR, size.height * 0.5),
            control1: CGPoint(glassR, size.height * 0.25),
            control2: CGPoint(smallR, size.height * 0.25)
            )
        context.addCurve(
            to: CGPoint(glassR, size.height),
            control1: CGPoint(smallR, size.height * 0.75),
            control2: CGPoint(glassR, size.height * 0.75)
            )
        context.addLine(to: CGPoint(x: bigR, y: size.height))
        context.addLine(to: CGPoint(x: -bigR, y: size.height))
        context.addLine(to: CGPoint(x: -glassR, y: size.height))
        context.addCurve(
            to: CGPoint(-smallR, size.height * 0.5),
            control1: CGPoint(-glassR, size.height * 0.75),
            control2: CGPoint(-smallR, size.height * 0.75)
            )
        context.addCurve(
            to: CGPoint(-glassR, 0),
            control1: CGPoint(-smallR, size.height * 0.25),
            control2: CGPoint(-glassR, size.height * 0.25)
            )
        context.addLine(to: CGPoint(x: -glassR, y: 0))
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

}
