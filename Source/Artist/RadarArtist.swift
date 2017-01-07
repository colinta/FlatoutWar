////
///  RadarArtist.swift
//


class BaseRadarArtist: Artist {
    let hasUpgrade: Bool
    let halfAngle: CGFloat
    let radius: CGFloat
    let color: UIColor
    let isSelected: Bool

    required init(hasUpgrade: Bool, radius: CGFloat, sweepAngle: CGFloat, color: UIColor, isSelected: Bool) {
        self.hasUpgrade = hasUpgrade
        self.radius = radius
        self.halfAngle = sweepAngle / 2
        self.color = color
        self.isSelected = isSelected

        super.init()

        size = CGSize(width: radius * cos(halfAngle), height: 2 * radius * sin(halfAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(hasUpgrade ? 2 : 1)

        let innerRadius: CGFloat = 25
        let c0 = CGPoint(x: 0, y: middle.y)
        let centerRight = CGPoint(x: size.width, y: middle.y)
        let centerInner = CGPoint(x: innerRadius, y: middle.y)

        let topRight = CGPoint(x: size.width, y: size.height)
        let bottomRight = CGPoint(x: size.width, y: 0)
        let bottomInner = CGPoint(r: innerRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)

        if isSelected {
            context.saveGState()
            context.move(to: bottomRight)
            context.addLine(to: bottomInner)
            context.addArc(center: c0, radius: innerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
            context.addLine(to: topRight)
            context.closePath()
            context.clip()

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGColor] = [
                UIColor(hex: BaseRadar1Color, alpha: 0.25).cgColor,
                UIColor(hex: BackgroundColor, alpha: 0.0).cgColor
            ]
            let locations: [CGFloat] = [0, 1]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
            context.drawLinearGradient(gradient, start: c0, end: centerRight, options: [])
            context.restoreGState()
        }

        context.setStrokeColor(color.cgColor)
        context.move(to: bottomRight)
        context.addLine(to: bottomInner)
        context.addArc(center: c0, radius: innerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: topRight)
        context.drawPath(using: .stroke)

        context.setAlpha(0.5)
        context.move(to: centerInner)
        context.addLine(to: CGPoint(x: radius, y: middle.y))
        context.drawPath(using: .stroke)
    }
}

class CannonRadarArtist: Artist {
    let hasUpgrade: Bool
    let halfAngle: CGFloat
    let minRadius: CGFloat
    let maxRadius: CGFloat
    let color: UIColor
    let isSelected: Bool

    required init(hasUpgrade: Bool, minRadius: CGFloat, maxRadius: CGFloat, sweepAngle: CGFloat, color: UIColor, isSelected: Bool) {
        self.hasUpgrade = hasUpgrade
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.halfAngle = sweepAngle / 2
        self.color = color
        self.isSelected = isSelected

        super.init()

        size = CGSize(width: maxRadius, height: 2 * maxRadius * sin(halfAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(hasUpgrade ? 2 : 1)
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)

        let c0 = CGPoint(x: 0, y: middle.y)

        let bottomLeft = CGPoint(r: minRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)
        let bottomRight = CGPoint(r: maxRadius, a: -halfAngle) + CGPoint(x: 0, y: size.height / 2)
        let topRight = CGPoint(r: maxRadius, a: halfAngle) + CGPoint(x: 0, y: size.height / 2)

        var values: [(CGFloat, CGPathDrawingMode)] = [(1, .stroke)]
        if isSelected {
            values << (0.25, .fill)
        }
        for (alpha, mode) in values {
            context.setAlpha(alpha)
            context.move(to: bottomRight)
            context.addLine(to: bottomLeft)
            context.addArc(center: c0, radius: minRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
            context.addLine(to: topRight)
            context.addArc(center: c0, radius: maxRadius, startAngle: halfAngle, endAngle: -halfAngle, clockwise: true)
            context.closePath()
            context.drawPath(using: mode)
        }
    }
}

class MissleRadarArtist: Artist {
    let hasUpgrade: Bool
    let radius: CGFloat
    let color: UIColor
    let isSelected: Bool

    required init(hasUpgrade: Bool, radius: CGFloat, color: UIColor, isSelected: Bool) {
        self.hasUpgrade = hasUpgrade
        self.radius = radius
        self.color = color
        self.isSelected = isSelected

        super.init()

        size = CGSize(r: radius)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(hasUpgrade ? 2 : 1)
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)

        if isSelected {
            context.setAlpha(0.5)
            context.addEllipse(in: CGRect(size: size))
            context.drawPath(using: .fill)
            context.setAlpha(1)
        }

        context.addEllipse(in: CGRect(size: size))
        context.drawPath(using: .stroke)

        context.translateBy(x: middle.x, y: middle.y)
        context.move(to: CGPoint(0, -size.height / 9))
        context.addLine(to: CGPoint(0, size.height / 9))
        context.move(to: CGPoint(-size.width / 9, 0))
        context.addLine(to: CGPoint(size.width / 9, 0))
        context.drawPath(using: .stroke)
    }
}

class LaserRadarArtist: Artist {
    let hasUpgrade: Bool
    let color: UIColor
    let isSelected: Bool

    required init(hasUpgrade: Bool, size: CGSize, color: UIColor, isSelected: Bool) {
        self.hasUpgrade = hasUpgrade
        self.color = color
        self.isSelected = isSelected

        super.init()

        self.size = size
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(hasUpgrade ? 2 : 1)

        let offset: CGFloat = 25

        if isSelected {
            context.saveGState()
            context.addRect(CGRect(x: offset, y: 0, width: size.width - offset, height: size.height))
            context.clip()

            let gradientStart = CGPoint(x: offset, y: middle.y)
            let gradientEnd = CGPoint(x: size.width, y: middle.y)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGColor] = [
                UIColor(hex: LaserRadarColor, alpha: 0.5).cgColor,
                UIColor(hex: BackgroundColor, alpha: 0.0).cgColor
            ]
            let locations: [CGFloat] = [0, 1]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
            context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: [])
            context.restoreGState()
        }

        let bottomRight = CGPoint(x: size.width, y: 0)
        let topRight = CGPoint(x: size.width, y: size.height)
        let bottomLeft = CGPoint(x: offset, y: 0)
        let topLeft = CGPoint(x: offset, y: size.height)

        context.setStrokeColor(color.cgColor)
        context.move(to: bottomRight)
        context.addLine(to: bottomLeft)
        context.addLine(to: topLeft)
        context.addLine(to: topRight)
        context.drawPath(using: .stroke)
    }
}

class ShotgunRadarArtist: Artist {
    let hasUpgrade: Bool
    let radius: CGFloat
    let halfAngle: CGFloat
    let color: UIColor
    let isSelected: Bool

    required init(hasUpgrade: Bool, radius: CGFloat, sweepAngle: CGFloat, color: UIColor, isSelected: Bool) {
        self.hasUpgrade = hasUpgrade
        self.radius = radius
        self.halfAngle = sweepAngle / 2
        self.color = color
        self.isSelected = isSelected

        super.init()

        size = CGSize(width: radius, height: 2 * radius * sin(halfAngle))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        context.setLineWidth(hasUpgrade ? 2 : 1)
        context.translateBy(x: 0, y: size.height / 2)

        let innerRadius: CGFloat = 20
        let outerRadius: CGFloat = size.width

        if isSelected {
            context.saveGState()
            context.move(to: .zero)
            context.addArc(center: .zero, radius: outerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
            context.closePath()
            context.clip()

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGColor] = [
                color.withAlphaComponent(0.25).cgColor,
                UIColor(hex: BackgroundColor, alpha: 0.0).cgColor
            ]
            let locations: [CGFloat] = [0, 1]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
            context.drawRadialGradient(gradient,
                startCenter: .zero,
                startRadius: innerRadius,
                endCenter: .zero,
                endRadius: outerRadius,
                options: [])
            context.restoreGState()
        }

        context.setStrokeColor(color.cgColor)
        context.move(to: CGPoint(r: innerRadius, a: -halfAngle))
        context.addArc(center: .zero, radius: outerRadius, startAngle: -halfAngle, endAngle: halfAngle, clockwise: false)
        context.addLine(to: CGPoint(r: innerRadius, a: halfAngle))
        context.addArc(center: .zero, radius: innerRadius, startAngle: halfAngle, endAngle: -halfAngle, clockwise: true)
        context.closePath()
        context.drawPath(using: .stroke)
    }
}
