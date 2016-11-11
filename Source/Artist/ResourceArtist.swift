////
///  ResourceArtist.swift
//

let ResourceBlue = 0x1158D9

class ResourceArtist: Artist {
    let remaining: CGFloat
    var color = UIColor(hex: ResourceBlue)

    required init(amount: CGFloat, remaining: CGFloat) {
        self.remaining = remaining
        super.init()
        size = CGSize(amount)
    }

    required convenience init() {
        self.init(amount: 30, remaining: 1)
    }

    override func draw(in context: CGContext) {
        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)
        let spokeRemaining = interpolate(remaining, from: (0, 1), to: (0.5, 1))
        let minBallSize: CGFloat = 1.5
        let spokeSize = max(size.width / 10 * spokeRemaining, minBallSize)
        let outerRadius = size.width / 2 - spokeSize
        let angles: [CGFloat] = [-TAU_4, TAU_12, 5 * TAU_12]
        var spokes: [CGPoint] = []
        for angle in angles {
            let pt = middle + CGPoint(r: outerRadius, a: angle)
            context.addEllipse(in: CGRect(center: pt, radius: spokeSize))
            spokes << pt
        }

        let innerRadius = outerRadius * remaining
        if innerRadius > 0 {
            context.addEllipse(in: CGRect(center: middle, radius: max(innerRadius, minBallSize)))
        }
        context.drawPath(using: .fill)

        var first = true
        for pt in spokes {
            if first {
                context.move(to: pt)
            }
            else {
                context.addLine(to: pt)
            }
            first = false
        }
        context.closePath()
        context.drawPath(using: .stroke)
    }

    func v1(_ context: CGContext) {
        let spokeSize: CGFloat = 5
        let outerRadius: CGFloat = size.width / 2 - spokeSize / 2
        let innerRadius: CGFloat = outerRadius - spokeSize
        let smallRadius: CGFloat = innerRadius - 3
        let angles: [CGFloat] = [-TAU_4, TAU_12, 5 * TAU_12]
        var first = true
        for angle in angles {
            let p0 = CGPoint(r: innerRadius, a: angle)
            let p1 = CGPoint(r: outerRadius, a: angle)
            var pts: [CGPoint] = []
            pts << (p0 + CGPoint(r: spokeSize / 2, a: angle - TAU_4))
            pts << (p1 + CGPoint(r: spokeSize / 2, a: angle - TAU_4))
            pts << (p1 + CGPoint(r: spokeSize / 2, a: angle + TAU_4))
            pts << (p0 + CGPoint(r: spokeSize / 2, a: angle + TAU_4))

            for pt in pts {
                if first {
                    context.move(to: middle + pt)
                }
                else {
                    context.addLine(to: middle + pt)
                }
                first = false
            }
        }
        context.closePath()

        first = true
        for angle in angles {
            let pt = CGPoint(r: smallRadius, a: angle)
            if first {
                context.move(to: middle + pt)
            }
            else {
                context.addLine(to: middle + pt)
            }
            first = false
        }
        context.closePath()

        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)
        context.fillPath(using: .evenOdd)
    }

}
