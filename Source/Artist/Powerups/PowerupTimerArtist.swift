////
///  PowerupTimerArtist.swift
//

class PowerupTimerArtist: Artist {
    var fillColor = UIColor(hex: 0xA00917)
    var strokeColor = UIColor(hex: PowerupRed)
    var percent: CGFloat

    required init(percent: CGFloat) {
        self.percent = percent
        super.init()
        size = CGSize(30)
    }

    convenience required init() {
        self.init(percent: 1)
    }

    override func draw(in context: CGContext) {
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)

        let a0 = -TAU_4
        let a1 = a0 - TAU * percent
        let p0 = middle + CGPoint(0, -size.height / 2)
        context.move(to: middle)
        context.addLine(to: p0)
        context.addArc(center: middle, radius: size.height / 2, startAngle: a0, endAngle: a1, clockwise: true)
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

}
