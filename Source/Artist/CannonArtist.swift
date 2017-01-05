////
///  CannonArtist.swift
//

var CannonBaseColor = 0xFFF71D
var CannonTurretFillColor = 0xFEC809
var CannonTurretStrokeColor = 0xC2B98F
var CannonRadar1Color = 0xFCF10C
var CannonRadar2Color = 0xE59311

class CannonArtist: PolygonArtist {
    required init(hasUpgrade: Bool, health: CGFloat) {
        super.init(pointCount: 5, health: health)

        baseColor = UIColor(hex: CannonBaseColor)
    }

    required init(pointCount: Int, health: CGFloat) {
        fatalError("init(pointCount:hasUpgrade:health:) has not been implemented")
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

class CannonBoxArtist: RectArtist {
    override func draw(in context: CGContext) {
        self.setup(in: context)

        let r: CGFloat = 5
        context.move(to: CGPoint(0, size.height - r))
        context.addLine(to: CGPoint(r, size.height))
        context.addLine(to: CGPoint(size.width, size.height))
        context.addLine(to: CGPoint(size.width, 0))
        context.addLine(to: CGPoint(r, 0))
        context.addLine(to: CGPoint(0, r))
        context.closePath()

        context.drawPath(using: drawingMode)
    }
}
