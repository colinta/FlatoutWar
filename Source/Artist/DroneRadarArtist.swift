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

    override func draw(in context: CGContext) {
        context.setStrokeColor(UIColor(hex: color).cgColor)
        context.setLineWidth(lineWidth)

        context.addEllipse(in: CGRect(center: middle, size: size))
        context.drawPath(using: .stroke)
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
