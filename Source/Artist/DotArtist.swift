////
///  DotArtist.swift
//

class DotArtist: Artist {
    var color = UIColor.white

    required init() {
        super.init()
        size = CGSize(2)
    }

    override func draw(in context: CGContext) {
        context.setFillColor(color.cgColor)
        context.addEllipse(in: CGRect(size: size))
        context.drawPath(using: .fill)
    }

}
