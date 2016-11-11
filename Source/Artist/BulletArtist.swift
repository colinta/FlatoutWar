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
        size = BulletArtist.bulletSize(upgrade: upgrade)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        let r = size.width / 2
        let bulletSize = r * BulletArtist.bulletSize(upgrade: upgrade)

        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)
        if bulletSize.width == bulletSize.height {
            context.addEllipse(in: CGRect(size: size))
            context.drawPath(using: .fill)
        }
        else {
            let r = bulletSize.height / 2
            context.move(to: CGPoint(x: middle.x - bulletSize.width / 2  + r, y: middle.y - r))
            context.addArc(center: CGPoint(middle.x + bulletSize.width / 2 - r, middle.y), radius: r, startAngle: -TAU_4, endAngle: TAU_4, clockwise: false)
            context.addArc(center: CGPoint(middle.x - bulletSize.width / 2  + r, middle.y), radius: r, startAngle: TAU_4, endAngle: -TAU_4, clockwise: false)
            context.drawPath(using: .fill)
        }
    }

}
