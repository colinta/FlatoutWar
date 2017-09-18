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

        context.addEllipse(in: CGRect(size: size))
        context.drawPath(using: .stroke)
    }
}

extension HasUpgrade {

    var droneRadarWidth: CGFloat {
        switch self {
        case .false: return 1
        case .true: return 2
        }
    }
    var droneRadarColor: Int {
        switch self {
        case .false: return DroneColor
        case .true: return DroneUpgradeColor
        }
    }

}
