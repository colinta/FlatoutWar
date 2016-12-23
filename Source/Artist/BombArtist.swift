////
///  BombArtist.swift
//

class BombArtist: Artist {
    let colorStart = (r: 0xE3, g: 0x45, b: 0x27)
    let colorEnd = (r: 0xBF, g: 0x09, b: 0x24)
    let time: CGFloat
    let radius: CGFloat
    private let maxRadius: CGFloat
    private let sizes: [CGFloat]

    required init(maxRadius: CGFloat, time: CGFloat) {
        self.time = time
        self.maxRadius = maxRadius
        self.radius = interpolate(time, from: (0, 1), to: (0, maxRadius))

        sizes = [
            0,
            0.1,
            0.2,
            0.33333,
            0.5,
            0.66667,
        ]

        super.init()
        size = CGSize(r: radius)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(in context: CGContext) {
        let r = Int(interpolate(time, from: (0, 1), to: (CGFloat(colorStart.r), CGFloat(colorEnd.r))))
        let g = Int(interpolate(time, from: (0, 1), to: (CGFloat(colorStart.g), CGFloat(colorEnd.g))))
        let b = Int(interpolate(time, from: (0, 1), to: (CGFloat(colorStart.b), CGFloat(colorEnd.b))))
        let a: Float = 1 - Float(time)
        let stroke = UIColor(red: r, green: g, blue: b, a: a)

        for t in sizes {
            if time < t { continue }
            let ellipseSize = CGSize(r: interpolate(time, from: (t, 1), to: (0, maxRadius)))
            context.addEllipse(in: CGRect(center: middle, size: ellipseSize))
        }

        context.setStrokeColor(stroke.cgColor)
        context.drawPath(using: .stroke)
    }

}
