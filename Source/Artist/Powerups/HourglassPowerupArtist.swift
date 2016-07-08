////
///  HourglassPowerupArtist.swift
//

class HourglassPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let bigR = size.width / 2 - 4
        let outerR = bigR - 3
        let glassR = bigR - 4
        let smallR = bigR - 10.5
        CGContextTranslateCTM(context, middle.x, 0)
        CGContextMoveToPoint(context, -bigR, 0)
        CGContextAddLineToPoint(context, -outerR, 0)
        CGContextAddLineToPoint(context, -outerR, size.height)
        CGContextAddLineToPoint(context, -outerR, 0)
        CGContextAddLineToPoint(context, outerR, 0)
        CGContextAddLineToPoint(context, outerR, size.height)
        CGContextAddLineToPoint(context, outerR, 0)
        CGContextAddLineToPoint(context, bigR, 0)
        CGContextAddLineToPoint(context, glassR, 0)
        CGContextAddCurveToPoint(context,
            glassR, size.height * 0.25,
            smallR, size.height * 0.25,
            smallR, size.height * 0.5)
        CGContextAddCurveToPoint(context,
            smallR, size.height * 0.75,
            glassR, size.height * 0.75,
            glassR, size.height)
        CGContextAddLineToPoint(context, bigR, size.height)
        CGContextAddLineToPoint(context, -bigR, size.height)
        CGContextAddLineToPoint(context, -glassR, size.height)
        CGContextAddCurveToPoint(context,
            -glassR, size.height * 0.75,
            -smallR, size.height * 0.75,
            -smallR, size.height * 0.5)
        CGContextAddCurveToPoint(context,
            -smallR, size.height * 0.25,
            -glassR, size.height * 0.25,
            -glassR, 0)
        CGContextAddLineToPoint(context, -glassR, 0)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
