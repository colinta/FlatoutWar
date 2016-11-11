////
///  NoPowerupArtist.swift
//

class NoPowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        context.translateBy(x: middle.x, y: middle.y)
        context.rotate(by: 45.degrees)

        let smallR: CGFloat = 2
        let bigR: CGFloat = middle.x
        context.move(to: CGPoint(x: -bigR, y: smallR))
        context.addLine(to: CGPoint(x: -bigR, y: -smallR))
        context.addLine(to: CGPoint(x: -smallR, y: -smallR))
        context.addLine(to: CGPoint(x: -smallR, y: -bigR))
        context.addLine(to: CGPoint(x: smallR, y: -bigR))
        context.addLine(to: CGPoint(x: smallR, y: -smallR))
        context.addLine(to: CGPoint(x: bigR, y: -smallR))
        context.addLine(to: CGPoint(x: bigR, y: smallR))
        context.addLine(to: CGPoint(x: smallR, y: smallR))
        context.addLine(to: CGPoint(x: smallR, y: bigR))
        context.addLine(to: CGPoint(x: -smallR, y: bigR))
        context.addLine(to: CGPoint(x: -smallR, y: smallR))
        context.closePath()

        context.drawPath(using: .fillStroke)
    }

}
