////
///  ShieldArtist.swift
//

class ShieldArtist: PowerupArtist {
    var phase: CGFloat = 0

    required init() {
        super.init()
        size = CGSize(r: 57)
    }

    override func draw(in context: CGContext) {
        super.draw(in: context)

        let smallR: CGFloat = 10
        let smallSize: CGSize = size - CGSize(r: smallR)
        let center1 = CGPoint(r: smallR, a: TAU * phase + TAU_3)
        let center2 = CGPoint(r: smallR, a: TAU * phase + TAU_2_3)
        let center3 = CGPoint(r: smallR, a: TAU * phase)
        context.translateBy(x: middle.x, y: middle.y)
        context.addEllipse(in: CGRect(center: center1, size: smallSize))
        context.addEllipse(in: CGRect(center: center2, size: smallSize))
        context.addEllipse(in: CGRect(center: center3, size: smallSize))
        context.drawPath(using: .stroke)
    }

}
