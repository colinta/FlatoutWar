////
///  HourglassZoneArtist.swift
//

class HourglassZoneArtist: Artist {
    var color = UIColor(hex: PowerupRed)

    required init() {
        super.init()
        size = CGSize(HourglassSize)
    }

    override func draw(context: CGContext) {
        let lineWidth: CGFloat = 1
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextAddEllipseInRect(context, CGRect(size: size))
        CGContextDrawPath(context, .Stroke)
    }

}
