////
///  WoodsBossArtist.swift
//

let WoodsBossFootColor = 0xD4007A
let WoodsBossBodyColor = 0xE04475

class WoodsBossFootArtist: Artist {
    fileprivate var color = UIColor(hex: WoodsBossFootColor)
    fileprivate var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(20)
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func drawingOffset() -> CGPoint {
        return .zero
    }

    override func draw(in context: CGContext) {
        context.setFillColor(color.cgColor)

        if health == 1 {
            context.addRect(CGRect(size: size))
            context.drawPath(using: .fill)
        }
        else {
            let y = size.height * (1 - health)

            context.addRect(CGRect(x: 0, y: y, width: size.width, height: size.height - y))
            context.drawPath(using: .fill)

            context.setAlpha(0.25)
            context.addRect(CGRect(size: size))
            context.drawPath(using: .fill)
        }
    }

}


class WoodsBossBodyArtist: WoodsBossFootArtist {

    required init(health: CGFloat) {
        super.init(health: health)
        color = UIColor(hex: WoodsBossBodyColor)
        size = CGSize(30)
    }
}
