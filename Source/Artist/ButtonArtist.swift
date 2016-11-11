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

    override func draw(in context: CGContext) {
        super.draw(in: context)

        context.setLineWidth(1)
        context.setStrokeColor(color.cgColor)

        switch style {
        case .Square, .SquareSized, .RectSized:
            context.addRect(CGRect(size: size))
            context.drawPath(using: .stroke)
        case .Circle, .CircleSized:
            context.addEllipse(in: CGRect(size: size))
            context.drawPath(using: .stroke)
        case .None, .RectToFit:
            break
        }
    }

}
