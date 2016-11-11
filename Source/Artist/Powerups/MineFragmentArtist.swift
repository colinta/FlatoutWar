////
///  MineFragmentArtist.swift
//

class MineFragmentArtist: PowerupArtist {

    required init() {
        super.init()
        size = CGSize(5)
    }

    override func draw(in context: CGContext) {
        super.draw(in: context)

        let d: CGFloat = 1.5
        let D: CGFloat = 2.5
        context.move(to: CGPoint(x: 0, y: middle.y + d))
        context.addLine(to: CGPoint(x: size.width, y: middle.y + D))
        context.addLine(to: CGPoint(x: size.width, y: middle.y - D))
        context.addLine(to: CGPoint(x: 0, y: middle.y - d))
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

}
