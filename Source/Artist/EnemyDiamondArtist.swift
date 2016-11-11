//  EnemyDiamondArtist.swift
//
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyDiamondArtist: Artist {
    private var color = UIColor(hex: EnemySoldierGreen)
    private var health: CGFloat

    required init(health: CGFloat) {
        self.health = health
        super.init()
        size = CGSize(20, 11.547005383792516)
    }

    required convenience init() {
        self.init(health: 1)
    }

    override func drawingOffset() -> CGPoint {
        return .zero
    }

    override func draw(in context: CGContext) {
        context.setFillColor(color.cgColor)

        if health < 1 {
            let x = size.width * health
            if x > middle.x {
                let y1 = interpolate(x, from: (size.width, middle.x), to: (middle.y, 0))
                let y2 = size.height - y1
                context.move(to: CGPoint(x: x, y: y1))
                context.addLine(to: CGPoint(x: middle.x, y: 0))
                context.addLine(to: CGPoint(x: 0, y: middle.y))
                context.addLine(to: CGPoint(x: middle.x, y: size.height))
                context.addLine(to: CGPoint(x: x, y: y2))
                context.closePath()
            }
            else {
                let y1 = interpolate(x, from: (0, middle.x), to: (middle.y, 0))
                let y2 = size.height - y1
                context.move(to: CGPoint(x: x, y: y1))
                context.addLine(to: CGPoint(x: 0, y: middle.y))
                context.addLine(to: CGPoint(x: x, y: y2))
                context.closePath()
            }
            context.drawPath(using: .fill)
            context.setAlpha(0.25)
        }

        context.move(to: CGPoint(x: size.width, y: middle.y))
        context.addLine(to: CGPoint(x: middle.x, y: 0))
        context.addLine(to: CGPoint(x: 0, y: middle.y))
        context.addLine(to: CGPoint(x: middle.x, y: size.height))
        context.closePath()
        context.drawPath(using: .fill)
    }

}
