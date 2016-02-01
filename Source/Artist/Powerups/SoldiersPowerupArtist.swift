//
//  SoldiersPowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class SoldiersPowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let soldierMargin: CGFloat = 2
        let soldierSize = size / 2 - CGSize(soldierMargin)

        for sx in [-1, 1] as [CGFloat] {
            for sy in [-1, 1] as [CGFloat] {
                let center = CGPoint(
                    middle.x + sx * (soldierMargin + soldierSize.width / 2),
                    middle.y + sy * (soldierMargin + soldierSize.width / 2)
                )
                CGContextAddRect(context, center.rectWithSize(soldierSize))
            }
        }
        CGContextDrawPath(context, .FillStroke)
    }

}
