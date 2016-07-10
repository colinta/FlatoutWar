////
///  DroneRadarArtist.swift
//

class DroneRadarArtist: Artist {
    var stroke = UIColor(hex: DroneColor)

    required init(radius: CGFloat) {
        super.init()

        size = CGSize(r: radius)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetLineWidth(context, 1)

        CGContextSetAlpha(context, alpha)
        CGContextAddEllipseInRect(context, middle.rect(size: size))
        CGContextDrawPath(context, .Stroke)
    }
}
