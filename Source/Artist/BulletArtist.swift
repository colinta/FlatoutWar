////
///  BulletArtist.swift
//

extension BulletNode.Style {

    var color: UIColor {
        switch self {
        case .Slow: return UIColor(hex: 0x9F0025)
        case .Fast: return UIColor(hex: 0xC70063)
        }
    }
}

class BulletArtist: Artist {
    var color: UIColor
    var upgrade: HasUpgrade = .False

    static func bulletSize(upgrade: HasUpgrade) -> CGSize {
        switch upgrade {
        case .False:
            return 3 * CGSize(width: 2, height: 2)
        case .True:
            return 3 * CGSize(width: 3, height: 1.333)
        }
    }

    required init(upgrade: HasUpgrade, style: BulletNode.Style) {
        self.upgrade = upgrade
        self.color = style.color
        super.init()
        size = BulletArtist.bulletSize(upgrade)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        let r = size.width / 2
        let bulletSize = r * BulletArtist.bulletSize(upgrade)

        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        if bulletSize.width == bulletSize.height {
            CGContextAddEllipseInRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Fill)
        }
        else {
            let r = bulletSize.height / 2
            CGContextMoveToPoint(context, middle.x - bulletSize.width / 2  + r, middle.y - r)
            CGContextAddArc(context, middle.x + bulletSize.width / 2 - r, middle.y, r, -TAU_4, TAU_4, 0)
            CGContextAddArc(context, middle.x - bulletSize.width / 2  + r, middle.y, r, TAU_4, -TAU_4, 0)
            CGContextDrawPath(context, .Fill)
        }
    }

}
