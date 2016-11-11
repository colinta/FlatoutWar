////
///  SoldiersPowerupArtist.swift
//

class SoldiersPowerupArtist: PowerupArtist {
    override func draw(in context: CGContext) {
        super.draw(in: context)

        let soldierMargin: CGFloat = 2
        let soldierSize = size / 2 - CGSize(soldierMargin * 2)

        for sx in [-1, 1] as [CGFloat] {
            for sy in [-1, 1] as [CGFloat] {
                let center = CGPoint(
                    middle.x + sx * (soldierMargin + soldierSize.width / 2),
                    middle.y + sy * (soldierMargin + soldierSize.width / 2)
                )
                context.addRect(CGRect(center: center, size: soldierSize))
            }
        }
        context.drawPath(using: .fillStroke)
    }

}
