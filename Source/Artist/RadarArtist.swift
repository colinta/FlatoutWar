////
///  RadarArtist.swift
//


class SectorRadarArtist: Artist {
    var halfAngle: CGFloat
    var radius: CGFloat
    var color: UIColor

    required init(radius: CGFloat, sweepAngle: CGFloat, color: UIColor) {
        self.radius = radius
        self.halfAngle = sweepAngle / 2
        self.color = color

        super.init()

        size = CGSize(width: radius * cos(halfAngle), height: 2 * radius * sin(halfAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(1.pixels)

        let innerRadius: CGFloat = 25
        let c0 = CGPoint(x: 0, y: middle.y)
        let centerRight = CGPoint(x: size.width, y: middle.y)
        let centerInner = CGPoint(x: innerRadius, y: middle.y)

        let topRight = CGPoint(x: size.width, y: size.height)
        let bottomRight = CGPoint(x: size.width, y: 0)
        let bottomInner = CGPoint(r: innerRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)

        context.saveGState()
        context.move(to: bottomRight)
        context.addLine(to: bottomInner)
        context.addArc(center: c0, radius: innerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: topRight)
        context.closePath()
        context.clip()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.9882, 0.9451, 0.0471, 0.25,
                                  0.2471, 0.2471, 0.2471, 0.0]
        let locations: [CGFloat] = [0, 1]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)!
        context.drawLinearGradient(gradient, start: c0, end: centerRight, options: [])
        context.restoreGState()

        context.setAlpha(0.5)
        context.setStrokeColor(color.cgColor)
        context.move(to: bottomRight)
        context.addLine(to: bottomInner)
        context.addArc(center: c0, radius: innerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: topRight)
        context.drawPath(using: .stroke)

        context.setAlpha(0.25)
        context.move(to: centerInner)
        context.addLine(to: CGPoint(x: radius, y: middle.y))
        context.drawPath(using: .stroke)
    }
}

class AnnulusRadarArtist: Artist {
    var halfAngle: CGFloat
    var minRadius: CGFloat
    var maxRadius: CGFloat
    var color: UIColor

    required init(minRadius: CGFloat, maxRadius: CGFloat, sweepAngle: CGFloat, color: UIColor) {
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.halfAngle = sweepAngle / 2
        self.color = color

        super.init()

        size = CGSize(width: maxRadius, height: 2 * maxRadius * sin(halfAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(1.pixels)

        let c0 = CGPoint(x: 0, y: middle.y)

        let bottomLeft = CGPoint(r: minRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)
        let bottomRight = CGPoint(r: maxRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)
        let topRight = CGPoint(r: maxRadius, a: halfAngle) + CGPoint(x: 0, y: size.height / 2)

        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)

        context.setAlpha(0.25)
        context.move(to: bottomRight)
        context.addLine(to: bottomLeft)
        context.addArc(center: c0, radius: minRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: topRight)
        context.addArc(center: c0, radius: maxRadius, startAngle: halfAngle, endAngle: -halfAngle, clockwise: true)
        context.closePath()
        context.drawPath(using: .fill)

        context.setAlpha(1)
        context.move(to: bottomRight)
        context.addLine(to: bottomLeft)
        context.addArc(center: c0, radius: minRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: topRight)
        context.addArc(center: c0, radius: maxRadius, startAngle: halfAngle, endAngle: -halfAngle, clockwise: true)
        context.closePath()
        context.drawPath(using: .stroke)
    }
}
