//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: World {
    var time: CGFloat = 0
    var sprites: [(SKNode, SKSpriteNode, a: CGFloat, offset: CGFloat, factor: CGFloat)] = []

    override func populateWorld() {
        20.times {
            sprites << (SKNode(), SKSpriteNode(id: .Box(color: EnemySoldierGreen)), a: rand(TAU), offset: rand(TAU), factor: rand(min: 1, max: 3))
        }

        for (node, sprite, angle, _, _) in sprites {
            node << sprite
            node.zRotation = angle
            self << node
        }
    }

    func p(t: CGFloat, r: CGFloat = 30) -> CGPoint {
        let x = r * (sin(t) + sin(-2 * t) * 0.5 - sin(4 * t))
        let y = r * (cos(t) + cos(-2 * t) * 0.5 - cos(4 * t))
        return CGPoint(x, y)
    }

    override func worldShook() {
        timeRate /= 2
        if timeRate < 0.125 {
            timeRate = 8
        }
    }

    override func update(dt: CGFloat) {
        time += dt

        for (_, sprite, _, offset, factor) in sprites {
            let t = factor * (time - offset * TAU)
            let p0 = p(t)
            let p1 = p(t + dt)
            sprite.position = p0
            sprite.zRotation = p0.angleTo(p1)
        }
    }

    func letters() {
        let letters = [
            "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V",
            "W","X","Y","Z","0","1","2","3","4","5","6","7","8","9",
        ]
        let dx: CGFloat = 50
        let dy: CGFloat = 30
        let x0: CGFloat = dx * -2.5
        let y0: CGFloat = dy * -2.5
        var x: CGFloat = x0
        var y: CGFloat = y0
        for letter in letters {
            let n = TextNode(at: CGPoint(x, y))
            n.font = .Big
            n.text = letter
            n.zRotation = TAU_4
            self << n

            if y < y0 + dy * 5 {
                y += dy
            }
            else {
                x += dx
                y = y0
            }
        }
    }

    func diamond() {
        let closeButton = CloseButton()
        closeButton.onTapped { _ in
            self.director?.presentWorld(MainMenuWorld())
        }
        ui << closeButton

        let r1: CGFloat = 10
        let r2: CGFloat = 17.320508075688775
        let locations: [(CGPoint, CGFloat)] = [
            (CGPoint(r: r1, a: 0), 0),
            (CGPoint(r: r1, a: TAU_6), TAU_6),
            (CGPoint(r: r1, a: TAU_3), TAU_3),
            (CGPoint(r: r1, a: TAU_2), TAU_2),
            (CGPoint(r: r1, a: TAU_2_3), TAU_2_3),
            (CGPoint(r: r1, a: TAU_5_6), TAU_5_6),

            (CGPoint(r: r2, a: 1 * TAU_12), 4 * TAU_12),
            (CGPoint(r: r2, a: 3 * TAU_12), 6 * TAU_12),
            (CGPoint(r: r2, a: 5 * TAU_12), 8 * TAU_12),
            (CGPoint(r: r2, a: 7 * TAU_12), 10 * TAU_12),
            (CGPoint(r: r2, a: 9 * TAU_12), 12 * TAU_12),
            (CGPoint(r: r2, a: 11 * TAU_12), 14 * TAU_12),
        ]

        for (position, angle) in locations {
            let n = EnemyDiamondNode(at: position)
            n.rotateTo(angle)
            self << n
        }
    }

}
