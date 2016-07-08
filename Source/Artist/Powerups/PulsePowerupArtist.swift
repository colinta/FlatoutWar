////
///  PulsePowerupArtist.swift
//

class PulsePowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let pulseRadii: [CGFloat] = [
            15,
            12,
            7.5,
        ]
        CGContextTranslateCTM(context, middle.x, middle.y)
        for pulseRadius in pulseRadii {
            CGContextAddEllipseInRect(context, CGPoint.zero.rect(size: CGSize(r: pulseRadius)))
            CGContextDrawPath(context, .FillStroke)
        }
    }

}
