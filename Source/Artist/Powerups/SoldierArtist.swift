////
///  SoldierArtist.swift
//

class SoldierArtist: Artist {
    private var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(10)
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func draw(in context: CGContext) {
        context.setFillColor(UIColor(hex: PowerupRed).cgColor)

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
