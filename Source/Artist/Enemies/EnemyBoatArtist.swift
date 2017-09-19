////
///  EnemyBoatArtist.swift
//

let EnemyBoatMagenta = 0xE100EA

class EnemyBoatArtist: Artist {
    fileprivate var color = UIColor(hex: EnemyBoatMagenta)

    required init() {
        super.init()
        let height: CGFloat = 20
        self.size = CGSize(width: 2 * height - 10, height: 20)
    }

    override func draw(in context: CGContext) {
        context.setFillColor(color.cgColor)

        let circleSize = CGSize(size.height)
        let rect1 = CGRect(origin: CGPoint(x: 0), size: circleSize)
        let rect2 = CGRect(origin: CGPoint(x: size.width - circleSize.width), size: circleSize)
        context.addEllipse(in: rect1)
        context.addEllipse(in: rect2)
        context.drawPath(using: .fill)
    }
}
