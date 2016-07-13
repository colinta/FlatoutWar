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

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
    }

}
