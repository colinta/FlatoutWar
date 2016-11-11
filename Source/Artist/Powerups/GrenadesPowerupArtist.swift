////
///  GrenadePowerupArtist.swift
//

class GrenadePowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let pinSize = CGSize(5)
        let grenadeSize = size * 0.75
        let smallWidth: CGFloat = 6
        let bigWidth: CGFloat = 10
        let bigHeight: CGFloat = size.height - grenadeSize.height - pinSize.height / 2
        let smallHeight: CGFloat = bigHeight / 3
        let a: CGFloat = atan2(smallWidth / 2, grenadeSize.height / 2)
        context.translateBy(x: middle.x, y: middle.y + bigHeight / 2)
        context.move(to: CGPoint(x: -smallWidth / 2, y: -grenadeSize.height / 2))
        context.addLine(to: CGPoint(x: -smallWidth / 2, y: -grenadeSize.height / 2 - smallHeight))

        let handleThickness: CGFloat = 2
        let handleLength: CGFloat = 6
        context.addLine(to: CGPoint(x: -bigWidth + smallWidth / 2 + handleThickness, y: -grenadeSize.height / 2 - smallHeight))
        context.addLine(to: CGPoint(x: -bigWidth + smallWidth / 2 + handleThickness - handleLength, y: -grenadeSize.height / 2 - smallHeight + handleLength))
        context.addLine(to: CGPoint(x: -bigWidth + smallWidth / 2 - handleLength, y: -grenadeSize.height / 2 - smallHeight + handleLength - handleThickness))
        context.addLine(to: CGPoint(x: -bigWidth + smallWidth / 2, y: -grenadeSize.height / 2 - smallHeight - handleThickness))

        context.addLine(to: CGPoint(x: -bigWidth + smallWidth / 2, y: -grenadeSize.height / 2 - bigHeight))
        context.addLine(to: CGPoint(x: smallWidth / 2, y: -grenadeSize.height / 2 - bigHeight))
        context.addLine(to: CGPoint(x: smallWidth / 2, y: -grenadeSize.height / 2))
        context.addArc(center: CGPoint(0, 0), radius: grenadeSize.width / 2, startAngle: -TAU_4 + a, endAngle: -TAU_4 - a, clockwise: false)
        context.closePath()
        context.drawPath(using: .fillStroke)

        let pinCenter = CGPoint(-bigWidth + smallWidth / 2, -grenadeSize.height / 2 - smallHeight - handleThickness)
        context.addEllipse(in: CGRect(center: pinCenter, size: pinSize))
        context.drawPath(using: .stroke)
    }

}
