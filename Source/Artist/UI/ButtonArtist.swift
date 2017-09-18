////
///  ButtonArtist.swift
//

extension ButtonStyle {

    var name: String {
        switch self {
        case let .circleSized(size):
            return "\(self)-size_\(size)"
        case let .squareSized(size):
            return "\(self)-size_\(size)"
        case let .rectSized(width, height):
            return "\(self)-width_\(width)-height_\(height)"
        default: return "\(self)"
        }
    }
}

class ButtonArtist: Artist {
    var style: ButtonStyle = .none
    var color = UIColor(hex: WhiteColor)

    override func draw(in context: CGContext) {
        super.draw(in: context)

        context.setLineWidth(1)
        context.setStrokeColor(color.cgColor)

        switch style {
        case .square, .squareSized, .rectSized:
            context.addRect(CGRect(size: size))
            context.drawPath(using: .stroke)
        case .circle, .circleSized:
            context.addEllipse(in: CGRect(size: size))
            context.drawPath(using: .stroke)
        case .none, .rectToFit:
            break
        }
    }

}
