////
///  PulsePowerupArtist.swift
//

class PulsePowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let pulseRadii: [CGFloat] = [
            15,
            12,
            7.5,
        ]
        context.translateBy(x: middle.x, y: middle.y)
        for pulseRadius in pulseRadii {
            context.addEllipse(in: CGRect(center: CGPoint.zero, size: CGSize(r: pulseRadius)))
            context.drawPath(using: .fillStroke)
        }
    }

}
