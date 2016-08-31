////
///  DroneRadarArtist.swift
//

class DroneRadarArtist: Artist {
    var color = DroneColor
    var lineWidth: CGFloat = 1

    required init(radius: CGFloat) {
        super.init()

        size = CGSize(r: radius)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, UIColor(hex: color).CGColor)
        CGContextSetLineWidth(context, lineWidth)

        CGContextAddEllipseInRect(context, middle.rect(size: size))
        CGContextDrawPath(context, .Stroke)
    }
}

extension FiveUpgrades {

    var droneRadarWidth: CGFloat {
        switch self {
        case .One: return 1
        case .Two: return 1.5
        case .Three: return 2
        case .Four: return 2.5
        case .Five: return 3
        }
    }
    var droneRadarColor: Int {
        switch self {
        case .One: return 0x25B1FF
        case .Two: return 0x2EC1FF
        case .Three: return 0x39D9FF
        case .Four: return 0x35ECFF
        case .Five: return 0x6CFFF1
        }
    }

}
