////
///  LaserPowerupArtist.swift
//

class LaserPowerupArtist: PowerupArtist {
    required init() {
        super.init()
        rotation = 45.degrees
    }

    override func draw(context: CGContext) {
        super.draw(context)

        let dy = size.height / 9 / 2
        let dx = size.width / 9
        let lines: [(sy: CGFloat, sx: CGFloat, length: CGFloat)] = [
            (sy: -2, sx: 0, length: 2),
            (sy: -2, sx: 3, length: 6),
            (sy: -1, sx: -0.5, length: 6.5),
            (sy: -1, sx: 7, length: 2.5),
            (sy: 0, sx: -1, length: 5),
            (sy: 0, sx: 5, length: 5),
            (sy: 1, sx: -0.5, length: 5),
            (sy: 1, sx: 5.5, length: 4),
            (sy: 2, sx: 0, length: 9),
        ]
        for (sy, sx, length) in lines {
            let start = CGPoint(sx * dx, middle.y + sy * dy)
            let dest = CGPoint((sx + length) * dx, middle.y + sy * dy)
            CGContextMoveToPoint(context, start.x, start.y)
            CGContextAddLineToPoint(context, dest.x, dest.y)
            CGContextDrawPath(context, .Stroke)
        }
    }

}
