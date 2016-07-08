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

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, UIColor(hex: PowerupRed).CGColor)

        if health == 1 {
            CGContextAddRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Fill)
        }
        else {
            let y = size.height * (1 - health)

            CGContextAddRect(context, CGRect(x: 0, y: y, width: size.width, height: size.height - y))
            CGContextDrawPath(context, .Fill)

            CGContextSetAlpha(context, 0.25)
            CGContextAddRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Fill)
        }
    }

}
