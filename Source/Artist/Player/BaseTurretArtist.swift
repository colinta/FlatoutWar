////
///  BaseTurretArtist.swift
//

class BaseTurretArtist: Artist {
    static let bigR: CGFloat = 5
    static let smallR: CGFloat = 3.5
    static let tinyR: CGFloat = 1
    static let width: CGFloat = 24

    var turretPath: CGMutablePath
    var bulletUpgrade: HasUpgrade
    var stroke = UIColor(hex: 0xFD9916)
    var fill = UIColor(hex: 0xD16806)

    required init(bulletUpgrade: HasUpgrade) {
        self.bulletUpgrade = bulletUpgrade
        turretPath = CGMutablePath()
        super.init()
        initialTurretPath()
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    func initialTurretPath() {
        turretPath.move(to: CGPoint(x: -BaseTurretArtist.bigR, y: -BaseTurretArtist.tinyR))
        turretPath.addLine(to: CGPoint(x: 0, y: -BaseTurretArtist.bigR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: -BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: 0, y: BaseTurretArtist.bigR))
        turretPath.addLine(to: CGPoint(x: -BaseTurretArtist.bigR, y: BaseTurretArtist.tinyR))
        turretPath.closeSubpath()
    }

    override func draw(in context: CGContext) {
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(fill.cgColor)

        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.addPath(turretPath)
        context.drawPath(using: .fillStroke)
    }
}

class BaseDoubleTurretArtist: BaseTurretArtist {
    static let doubleDist: CGFloat = 6

    required init(bulletUpgrade: HasUpgrade) {
        super.init(bulletUpgrade: bulletUpgrade)
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func initialTurretPath() {
        turretPath.move(to: CGPoint(x: -BaseTurretArtist.bigR, y: -BaseTurretArtist.tinyR))
        turretPath.addLine(to: CGPoint(x: 0, y: -BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: -BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: 0, y: BaseTurretArtist.smallR))
        turretPath.addLine(to: CGPoint(x: -BaseTurretArtist.bigR, y: BaseTurretArtist.tinyR))
        turretPath.closeSubpath()
    }

    override func draw(in context: CGContext) {
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(fill.cgColor)

        let centers = [
            CGPoint(x: size.width / 2, y: size.height / 2 + BaseDoubleTurretArtist.doubleDist),
            CGPoint(x: size.width / 2, y: size.height / 2 - BaseDoubleTurretArtist.doubleDist),
        ]
        for center in centers {
            context.saveGState()
            context.translateBy(x: center.x, y: center.y)
            context.addPath(turretPath)
            context.restoreGState()
        }

        context.drawPath(using: .fillStroke)
    }

}

class BaseBigTurretArtist: BaseTurretArtist {
    static let biggerR: CGFloat = 7
    static let smallerR: CGFloat = 5.5
    static let tinierR: CGFloat = 2

    required init(bulletUpgrade: HasUpgrade) {
        super.init(bulletUpgrade: bulletUpgrade)
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func initialTurretPath() {
        turretPath.move(to: CGPoint(x: -BaseBigTurretArtist.biggerR, y: -BaseBigTurretArtist.tinierR))
        turretPath.addLine(to: CGPoint(x: 0, y: -BaseBigTurretArtist.biggerR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: -BaseBigTurretArtist.biggerR))
        turretPath.addLine(to: CGPoint(x: BaseTurretArtist.width, y: BaseBigTurretArtist.biggerR))
        turretPath.addLine(to: CGPoint(x: 0, y: BaseBigTurretArtist.biggerR))
        turretPath.addLine(to: CGPoint(x: -BaseBigTurretArtist.biggerR, y: BaseBigTurretArtist.tinierR))
        turretPath.closeSubpath()
    }

}
