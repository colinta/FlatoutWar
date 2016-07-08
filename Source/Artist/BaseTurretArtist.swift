////
///  BaseTurretArtist.swift
//

class BaseTurretArtist: Artist {
    static let bigR: CGFloat = 5
    static let smallR: CGFloat = 3.5
    static let tinyR: CGFloat = 1
    static let width: CGFloat = 24

    private var turretPath: CGMutablePath
    var upgrade: FiveUpgrades
    var stroke = UIColor(hex: 0xFD9916)
    var fill = UIColor(hex: 0xD16806)

    required init(upgrade: FiveUpgrades) {
        self.upgrade = upgrade
        turretPath = CGPathCreateMutable()
        super.init()
        initialTurretPath()
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    func initialTurretPath() {
        CGPathMoveToPoint(turretPath, nil, -BaseTurretArtist.bigR, -BaseTurretArtist.tinyR)
        CGPathAddLineToPoint(turretPath, nil, 0, -BaseTurretArtist.bigR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, -BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, 0, BaseTurretArtist.bigR)
        CGPathAddLineToPoint(turretPath, nil, -BaseTurretArtist.bigR, BaseTurretArtist.tinyR)
        CGPathCloseSubpath(turretPath)
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, fill.CGColor)

        CGContextTranslateCTM(context, size.width / 2, size.height / 2)
        CGContextAddPath(context, turretPath)
        CGContextDrawPath(context, .FillStroke)
    }
}

class BaseRapidTurretArtist: BaseTurretArtist {
    static let biggerR: CGFloat = 6
    static let smallerR: CGFloat = 2.5

    required init(upgrade: FiveUpgrades) {
        super.init(upgrade: upgrade)
        size = CGSize(48)
        stroke = UIColor(hex: 0xFD9916)
        fill = UIColor(hex: 0xD1391A)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func initialTurretPath() {
        CGPathMoveToPoint(turretPath, nil, -BaseRapidTurretArtist.biggerR, -BaseRapidTurretArtist.tinyR)
        CGPathAddLineToPoint(turretPath, nil, 0, -BaseRapidTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, BaseRapidTurretArtist.smallerR, -BaseRapidTurretArtist.smallerR)
        CGPathAddLineToPoint(turretPath, nil, BaseRapidTurretArtist.width, -BaseRapidTurretArtist.smallerR)
        CGPathAddLineToPoint(turretPath, nil, BaseRapidTurretArtist.width, BaseRapidTurretArtist.smallerR)
        CGPathAddLineToPoint(turretPath, nil, BaseRapidTurretArtist.smallerR, BaseRapidTurretArtist.smallerR)
        CGPathAddLineToPoint(turretPath, nil, 0, BaseRapidTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, -BaseRapidTurretArtist.biggerR, BaseRapidTurretArtist.tinyR)
        CGPathCloseSubpath(turretPath)
    }

}

class BaseDoubleTurretArtist: BaseTurretArtist {
    static let doubleDist: CGFloat = 6

    required init(upgrade: FiveUpgrades) {
        super.init(upgrade: upgrade)
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func initialTurretPath() {
        CGPathMoveToPoint(turretPath, nil, -BaseTurretArtist.bigR, -BaseTurretArtist.tinyR)
        CGPathAddLineToPoint(turretPath, nil, 0, -BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, -BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, 0, BaseTurretArtist.smallR)
        CGPathAddLineToPoint(turretPath, nil, -BaseTurretArtist.bigR, BaseTurretArtist.tinyR)
        CGPathCloseSubpath(turretPath)
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        CGContextSetFillColorWithColor(context, fill.CGColor)

        let centers = [
            CGPoint(x: size.width / 2, y: size.height / 2 + BaseDoubleTurretArtist.doubleDist),
            CGPoint(x: size.width / 2, y: size.height / 2 - BaseDoubleTurretArtist.doubleDist),
        ]
        for center in centers {
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, center.x, center.y)
            CGContextAddPath(context, turretPath)
            CGContextRestoreGState(context)
        }

        CGContextDrawPath(context, .FillStroke)
    }

}

class BaseBigTurretArtist: BaseTurretArtist {
    static let biggerR: CGFloat = 7
    static let smallerR: CGFloat = 5.5
    static let tinierR: CGFloat = 2

    required init(upgrade: FiveUpgrades) {
        super.init(upgrade: upgrade)
        size = CGSize(48)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func initialTurretPath() {
        CGPathMoveToPoint(turretPath, nil, -BaseBigTurretArtist.biggerR, -BaseBigTurretArtist.tinierR)
        CGPathAddLineToPoint(turretPath, nil, 0, -BaseBigTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, -BaseBigTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, BaseTurretArtist.width, BaseBigTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, 0, BaseBigTurretArtist.biggerR)
        CGPathAddLineToPoint(turretPath, nil, -BaseBigTurretArtist.biggerR, BaseBigTurretArtist.tinierR)
        CGPathCloseSubpath(turretPath)
    }

}
