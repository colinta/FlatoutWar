////
///  PercentArtist.swift
//

enum PercentStyle {
    static let `default`: PercentStyle = .experience
    case experience
    case heat

    var color: Int {
        switch self {
        case .experience: return EnemySoldierGreen
        default: return 0
        }
    }
    var completeColor: Int {
        switch self {
        case .experience: return 0x5BBC1A
        default: return 0
        }
    }

}

class PercentArtist: Artist {
    var complete: CGFloat = 1.0
    var style: PercentStyle

    required init(style: PercentStyle) {
        self.style = style
        super.init()
        switch style {
        case .experience:
            size = CGSize(width: 60, height: 5)
        case .heat:
            size = CGSize(width: 4, height: 35)
        }
    }

    required convenience init() {
        self.init(style: .default)
    }

    override func draw(in context: CGContext) {
        switch style {
        case .experience:
            let smallWidth = size.width * complete
            context.setAlpha(0.5)
            context.setFillColor(UIColor(hex: style.color).cgColor)
            context.addRect(CGRect(size: size))
            context.drawPath(using: .fill)

            context.setAlpha(1)
            context.setFillColor(UIColor(hex: style.completeColor).cgColor)
            context.addRect(CGRect(size: CGSize(smallWidth, size.height)))
            context.drawPath(using: .fill)
        case .heat:
            let smallHeight = size.height * complete
            context.addRect(CGRect(x: 0, y: size.height - smallHeight, width: size.width, height: smallHeight))
            context.clip()

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGColor] = [
                UIColor(hex: 0xFFFF00, alpha: 1).cgColor,
                UIColor(hex: 0xFF0000, alpha: 1).cgColor
            ]
            let locations: [CGFloat] = [0, 1]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
            context.drawLinearGradient(gradient, start: CGPoint(y: 0), end: CGPoint(y: size.height), options: [])
        }
    }

}
