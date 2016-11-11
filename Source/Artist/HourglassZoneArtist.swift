////
///  HourglassZoneArtist.swift
//

class HourglassZoneArtist: Artist {
    var color = UIColor(hex: PowerupRed)

    required init() {
        super.init()
        size = CGSize(HourglassSize)
    }

    override func draw(in context: CGContext) {
        let lineWidth: CGFloat = 1
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.addEllipse(in: CGRect(size: size))
        context.drawPath(using: .stroke)
    }

}
