////
///  NetPowerupArtist.swift
//

class NetPowerupArtist: PowerupArtist {
    var fill = true
    var phase: CGFloat = 0

    override func draw(in context: CGContext) {
        super.draw(in: context)

        context.addEllipse(in: CGRect(center: middle, size: size))
        if fill {
            context.drawPath(using: .fillStroke)
        }
        else {
            context.drawPath(using: .stroke)
        }

        let r = size.width / 2
        let rSquared = pow(r, 2)
        let dx = size.width / 6
        let dy = size.height / 6

        context.setAlpha(0.5)
        context.translateBy(x: middle.x, y: middle.y)
        let factor: CGFloat = 0.1 * abs(sin(phase * TAU))
        for s in [-1.5, -0.5, 0.5, 1.5] as [CGFloat] {
            let sign: CGFloat = abs(s) / s
            do {
                let x1 = (s + factor * sign) * dx
                let x2 = (s + factor * sign) * dx * 1.6
                let y0: CGFloat = 0
                let y1: CGFloat = sqrt(rSquared - pow(x1, 2))
                let y2 = -y1
                context.move(to: CGPoint(x: x1, y: y1))
                context.addQuadCurve(to: CGPoint(x1, y2), control: CGPoint(x2, y0))
            }

            do {
                let y1 = (s + factor * sign) * dy
                let y2 = (s + factor * sign) * dy * 1.6
                let x0: CGFloat = 0
                let x1: CGFloat = sqrt(rSquared - pow(y1, 2))
                let x2 = -x1
                context.move(to: CGPoint(x: x1, y: y1))
                context.addQuadCurve(to: CGPoint(x2, y1), control: CGPoint(x0, y2))
            }
        }
        context.drawPath(using: .stroke)
    }

}
