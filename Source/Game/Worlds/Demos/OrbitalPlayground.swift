//
//  OrbitalPlayground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class OrbitalPlayground: World {
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

}
