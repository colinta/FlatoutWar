////
///  MissleSiloArtist.swift
//

var MissleSiloBaseColor = 0xC82A04
var MissleSiloFillColor = 0xA12403
var MissleSiloStrokeColor = 0x937067
var MissleSiloRadarColor = 0xA12403

class MissleSiloArtist: PolygonArtist {
    required init(hasUpgrade: Bool, health: CGFloat) {
        super.init(pointCount: 6, health: health)

        baseColor = UIColor(hex: MissleSiloBaseColor)
    }

    required init(pointCount: Int, health: CGFloat) {
        fatalError("init(pointCount:hasUpgrade:health:) has not been implemented")
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

class MissleSiloBoxArtist: RectArtist {
    // required init(_ size: CGSize, _ color: UIColor) {
    //     super.init(size, color)
    //     self.size = size
    // }

    // override func draw(in context: CGContext) {
    //     self.setup(in: context)
    // }
}

class MissleArtist: ShapeArtist {
    required init() {
        super.init()
        self.fillColor = UIColor(hex: MissleSiloFillColor)
        self.strokeColor = UIColor(hex: MissleSiloStrokeColor)
        self.size = CGSize(10, 7)
    }

    override func draw(in context: CGContext) {
        self.setup(in: context)

        let r: CGFloat = 2
        context.move(to: CGPoint(size.width, middle.y - r))
        context.addLine(to: CGPoint(size.width, middle.y + r))
        context.addLine(to: CGPoint(size.width - r, size.height))
        context.addLine(to: CGPoint(0, size.height))
        context.addLine(to: CGPoint(0, 0))
        context.addLine(to: CGPoint(size.width - r, 0))
        context.closePath()

        context.drawPath(using: drawingMode)
    }
}
