////
///  SoldiersPowerupArtist.swift
//

class SoldiersPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let soldierMargin: CGFloat = 2
        let soldierSize = size / 2 - CGSize(soldierMargin * 2)

        for sx in [-1, 1] as [CGFloat] {
            for sy in [-1, 1] as [CGFloat] {
                let center = CGPoint(
                    middle.x + sx * (soldierMargin + soldierSize.width / 2),
                    middle.y + sy * (soldierMargin + soldierSize.width / 2)
                )
                CGContextAddRect(context, center.rect(size: soldierSize))
            }
        }
        CGContextDrawPath(context, .FillStroke)
    }

}
