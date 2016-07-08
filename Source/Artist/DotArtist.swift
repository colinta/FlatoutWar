////
///  DotArtist.swift
//

class DotArtist: Artist {
    var color = UIColor.whiteColor()

    required init() {
        super.init()
        size = CGSize(2)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddEllipseInRect(context, CGRect(size: size))
        CGContextDrawPath(context, .Fill)
    }

}
