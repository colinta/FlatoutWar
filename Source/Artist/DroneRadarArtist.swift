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

extension HasUpgrade {

    var droneRadarWidth: CGFloat {
        switch self {
        case .False: return 1
        case .True: return 2
        }
    }
    var droneRadarColor: Int {
        switch self {
        case .False: return DroneColor
        case .True: return DroneUpgradeColor
        }
    }

}
