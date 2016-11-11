////
///  PowerupArtist.swift
//

let PowerupRed = 0xD92222

class PowerupArtist: Artist {
    var fillColor = UIColor(hex: BlackColor)
    var strokeColor = UIColor(hex: PowerupRed)

    required init() {
        super.init()
        size = CGSize(30)
    }

    override func draw(in context: CGContext) {
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
    }

}
