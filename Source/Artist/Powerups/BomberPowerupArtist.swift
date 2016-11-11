////
///  BomberPowerupArtist.swift
//

class BomberPowerupArtist: PowerupArtist {
    var numBombs: Int = 8

    override func draw(in context: CGContext) {
        super.draw(in: context)

        let margin: CGFloat = 5
        let maxDim = min(size.width, size.height) - margin
        let minDim = margin
        let centerDim = (maxDim + minDim) / 2
        let innerX = minDim + (maxDim - minDim) / 7
        context.move(to: CGPoint(x: maxDim, y: centerDim))
        context.addLine(to: CGPoint(x: minDim, y: maxDim))
        context.addLine(to: CGPoint(x: innerX, y: centerDim))
        context.addLine(to: CGPoint(x: minDim, y: minDim))
        context.closePath()
        context.drawPath(using: .fillStroke)

        let dist: CGFloat = (maxDim - minDim) / 4
        let angle = atan2(centerDim - minDim, maxDim - minDim)
        let smallDim: CGFloat = 3

        var x = maxDim, y1 = centerDim, y2 = centerDim - smallDim
        var remainingBombs = numBombs
        4.times {
            guard remainingBombs > 0 else { return }

            x -= dist * cos(angle)
            y1 += dist * sin(angle)
            y2 -= dist * sin(angle)

            for y in [y1, y2] {
                let rect = CGRect(
                    x: x, y: y,
                    width: smallDim, height: smallDim
                )
                context.addEllipse(in: rect)

                remainingBombs -= 1
                if remainingBombs <= 0 { break }
            }
            context.drawPath(using: .fillStroke)
        }
    }

}
