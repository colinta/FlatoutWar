////
///  CoffeePowerupArtist.swift
//

class CoffeePowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let bigR: CGFloat = 10
        let smallR: CGFloat = 3
        let mugHeight: CGFloat = size.height * 0.6
        let handleHeight = mugHeight * 0.8
        let handleThickness: CGFloat = 3
        let handleWidth: CGFloat = 8
        let handleLeft: CGFloat = 2
        let handleUp: CGFloat = 3

        context.translateBy(x: bigR + handleWidth / 2, y: size.height - mugHeight / 2 - smallR)
        context.move(to: CGPoint(x: -bigR, y: mugHeight / 2))
        context.addLine(to: CGPoint(x: -bigR, y: -mugHeight / 2))

        let arcRadius = mugHeight / 2 + smallR
        context.addCurve(
            to: CGPoint(-smallR, -arcRadius),
            control1: CGPoint(smallR, -arcRadius),
            control2: CGPoint(bigR, -mugHeight / 2)
            )
        context.addLine(to: CGPoint(x: bigR, y: mugHeight / 2))
        context.addCurve(
            to: CGPoint(smallR, arcRadius),
            control1: CGPoint(-smallR, arcRadius),
            control2: CGPoint(-bigR, mugHeight / 2)
            )
        context.closePath()
        context.drawPath(using: .fillStroke)

        // inner mug edge
        context.move(to: CGPoint(x: -bigR, y: -mugHeight / 2))
        context.addCurve(
            to: CGPoint(-smallR, -arcRadius + smallR * 2),
            control1: CGPoint(smallR, -arcRadius + smallR * 2),
            control2: CGPoint(bigR, -mugHeight / 2)
            )
        context.drawPath(using: .stroke)

        // steam lines
        let steamR: CGFloat = 3
        let steamHeight: CGFloat = 6
        let steamX: [CGFloat] = [-bigR / 2, 0, bigR / 2]
        for x in steamX {
            context.saveGState()
            context.translateBy(x: x, y: -mugHeight / 2 - smallR)
            context.move(to: .zero)
            context.addCurve(
                to: CGPoint(steamR, -steamHeight / 2),
                control1: CGPoint(-steamR, -steamHeight / 2),
                control2: CGPoint(0, -steamHeight)
                )
            context.drawPath(using: .stroke)
            context.restoreGState()
        }

        // mug handle
        context.translateBy(x: bigR - handleLeft, y: 0)
        for pathFill in [true, false] {
            context.move(to: CGPoint(x: 0, y: -handleHeight / 2 + handleUp))
            context.addCurve(
                to: CGPoint(handleWidth, -handleHeight / 2 - handleUp),
                control1: CGPoint(handleWidth, handleHeight / 2 + handleUp),
                control2: CGPoint(0, handleHeight / 2 - handleUp)
                )
            if !pathFill {
                context.drawPath(using: .stroke)
                context.move(to: CGPoint(x: 0, y: handleHeight / 2 - handleUp - handleThickness))
            }
            else {
                context.addLine(to: CGPoint(x: 0, y: handleHeight / 2 - handleUp - handleThickness))
            }
            context.addCurve(
                to: CGPoint(handleWidth - handleThickness, handleHeight / 2 + handleUp - handleThickness),
                control1: CGPoint(handleWidth - handleThickness, -handleHeight / 2 - handleUp + handleThickness),
                control2: CGPoint(0, -handleHeight / 2 + handleUp + handleThickness)
                )
            if pathFill {
                context.closePath()
                context.drawPath(using: .fill)
            }
            else {
                context.drawPath(using: .stroke)
            }
        }
    }

}
