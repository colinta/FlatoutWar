////
///  EnemySoldierArtist.swift
//

let EnemySoldierGreen = 0x3E8012

class EnemySoldierArtist: Artist {
    fileprivate var color = UIColor(hex: EnemySoldierGreen)
    fileprivate var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(10)
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

class EnemySlowSoldierArtist: EnemySoldierArtist {
    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(8)
        color = UIColor(hex: 0x3544FF)
    }
}

class EnemyFastSoldierArtist: EnemySoldierArtist {
    required init(health: CGFloat) {
        super.init(health: health)
        color = UIColor(hex: 0x36FF3A)
    }
}

class EnemyLeaderArtist: EnemySoldierArtist {
    private let darkColor = UIColor(hex: 0x234B0C)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(20)
    }

    override func draw(in context: CGContext) {
        context.saveGState()
        super.draw(in: context)
        context.restoreGState()

        context.setLineWidth(2.0)
        context.setStrokeColor(darkColor.cgColor)
        context.move(to: CGPoint(x: size.width * 0.75, y: 0))
        context.addLine(to: CGPoint(x: size.width * 0.75, y: size.height))
        context.drawPath(using: .stroke)
    }

}


class EnemyScoutArtist: EnemySoldierArtist {
    private let darkColor = UIColor(hex: 0xBCA600)

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(8)
        color = UIColor(hex: 0xEED200)
    }

    override func draw(in context: CGContext) {
        context.saveGState()
        super.draw(in: context)
        context.restoreGState()

        context.setLineWidth(1)
        context.setFillColor(darkColor.cgColor)
        let stroke: CGFloat = 0.5
        context.move(to: CGPoint(x: size.width * 0.75 + stroke, y: 0))
        context.addLine(to: CGPoint(x: size.width * 0.75 - stroke, y: 0))
        context.addLine(to: CGPoint(x: size.width * 0.25 - stroke, y: size.height))
        context.addLine(to: CGPoint(x: size.width * 0.25 + stroke, y: size.height))
        context.drawPath(using: .fill)
    }

}

class EnemyDozerArtist: EnemySoldierArtist {

    required init(health: CGFloat) {
        super.init(health: health)
        size = CGSize(width: 5, height: 50)
        color = UIColor(hex: 0x825A11)
    }

}
