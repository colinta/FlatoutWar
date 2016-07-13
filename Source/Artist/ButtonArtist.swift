////
///  ButtonArtist.swift
//

extension ButtonStyle {

    var name: String {
        switch self {
        case let .CircleSized(size):
            return "\(self)-size_\(size)"
        case let .SquareSized(size):
            return "\(self)-size_\(size)"
        case let .RectSized(width, height):
            return "\(self)-width_\(width)-height_\(height)"
        default: return "\(self)"
        }
    }
}

class ButtonArtist: Artist {
    var style: ButtonStyle = .None
    var color = UIColor(hex: WhiteColor)

    override func draw(context: CGContext) {
        super.draw(context)

        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        switch style {
        case .Square, .SquareSized, .RectSized:
            CGContextAddRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Stroke)
        case .Circle, .CircleSized:
            CGContextAddEllipseInRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Stroke)
        case .None, .RectToFit:
            break
        }
    }

}
