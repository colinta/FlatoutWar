////
///  EnemyJetArtist.swift
//

class EnemyJetArtist: Artist {
    private var color = UIColor(hex: 0xFA5BDD)
    private var health: CGFloat
    private var innerX: CGFloat { return size.width / 5 }

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(8)
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
            context.move(to: CGPoint(x: size.width, y: middle.y))
            context.addLine(to: CGPoint(x: 0, y: size.height))
            context.addLine(to: CGPoint(x: innerX, y: middle.y))
            context.addLine(to: .zero)
            context.closePath()
            context.drawPath(using: .fill)
        }
        else {
            let x = size.width * (1 - health)
            let healthX = max(innerX, x)
            let deltaY = health * size.height / 2

            context.move(to: CGPoint(x: size.width, y: middle.y))
            context.addLine(to: CGPoint(x: x, y: middle.y + deltaY))
            context.addLine(to: CGPoint(x: healthX, y: middle.y))
            context.addLine(to: CGPoint(x: x, y: middle.y - deltaY))
            context.closePath()
            context.drawPath(using: .fill)

            context.setAlpha(0.25)
            context.move(to: CGPoint(x: size.width, y: middle.y))
            context.addLine(to: CGPoint(x: 0, y: size.height))
            context.addLine(to: CGPoint(x: innerX, y: middle.y))
            context.addLine(to: .zero)
            context.closePath()
            context.drawPath(using: .fill)
        }
    }

}

class EnemyBigJetArtist: EnemyJetArtist {
    private let darkColor = UIColor(hex: 0xAC3E97)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(16)
    }

    override func draw(in context: CGContext) {
        context.saveGState()
        super.draw(in: context)
        context.restoreGState()

        context.setFillColor(darkColor.cgColor)
        let dx: CGFloat = 1
        let dy: CGFloat = 0.5
        context.move(to: CGPoint(x: size.width * 1/4 - dx, y: size.height * 1/8 - dy))
        context.addLine(to: CGPoint(x: size.width * 1/4 - dx, y: size.height * 7/8 + dy))
        context.addLine(to: CGPoint(x: size.width * 1/4 + dx, y: size.height * 7/8 - dy))
        context.addLine(to: CGPoint(x: size.width * 1/4 + dx, y: size.height * 1/8 + dy))
        context.closePath()
        context.drawPath(using: .fill)
    }

}

class EnemyJetTransportArtist: EnemyJetArtist {
    private let darkColor = UIColor(hex: 0xAC3E97)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(40)
    }

    override func draw(in context: CGContext) {

        context.saveGState()
        super.draw(in: context)
        context.restoreGState()

        context.setLineWidth(1.0)
        context.setStrokeColor(darkColor.cgColor)
        context.move(to: CGPoint(x: size.width * 1/4, y: size.height * 1/8))
        context.addLine(to: CGPoint(x: size.width * 1/4, y: size.height * 7/8))
        context.move(to: CGPoint(x: size.width * 3/8, y: size.height * 3/16))
        context.addLine(to: CGPoint(x: size.width * 3/8, y: size.height * 13/16))
        context.drawPath(using: .stroke)
    }

}
