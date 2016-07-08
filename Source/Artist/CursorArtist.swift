////
///  CursorArtist.swift
//

class CursorArtist: Artist {
    var color = UIColor(hex: 0x1158D9)

    required init() {
        super.init()
        size = CGSize(80)
    }

    override func draw(context: CGContext) {
        let lineWidth: CGFloat = 2
        let radius = middle.x - lineWidth / 2
        let numArcs = 18
        for i in 0..<numArcs {
            let a1 = CGFloat(2 * i) * TAU_2 / CGFloat(numArcs)
            let a2 = CGFloat(2 * i + 1) * TAU_2 / CGFloat(numArcs)
            let pt = CGPoint(r: radius, a: a1)
            CGContextMoveToPoint(context, middle.x + pt.x, middle.y + pt.y)
            CGContextAddArc(context, middle.x, middle.y, radius, a1, a2, 0)
        }
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextDrawPath(context, .Stroke)
    }

}
