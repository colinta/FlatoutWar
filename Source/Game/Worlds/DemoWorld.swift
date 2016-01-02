//
//  DemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DemoWorld: World {

    override func populateWorld() {
        timeRate = 1

        let playerNode = BasePlayerNode()
        defaultNode = playerNode
        self << playerNode

        let drone = DroneNode(at: CGPoint(100, 50))
        self << drone

        // let minX = -size.width / 2 + 20, maxX = size.width / 2 - 20
        // let minY = -size.height / 2 + 20
        // var x: CGFloat = minX
        // var y: CGFloat = minY
        // for i in 0...90 {
        //     let id: ImageIdentifier = .HueLine(length: CGFloat(i) / 10, hue: 20)
        //     let image = Artist.generate(id)

        //     x += image.size.width + 10
        //     if x > maxX {
        //         x = minX
        //         y += image.size.height + 10
        //     }

        //     let sprite = SKSpriteNode(id: id)
        //     sprite.position = CGPoint(x, y)
        //     self << sprite
        // }

        let count = 30
        let radius: CGFloat = 200
        for angleIndex in 0...count {
            let angle = TAU * CGFloat(angleIndex) / CGFloat(count)
            let enemyNode = EnemySoldierNode(at: CGPoint(r: radius, a: angle))
            enemyNode.rotateTowards(node: playerNode)
            self << enemyNode
        }

        timeRate = 0.5
        timeline.every(3.5) {
            self << PlayerExplosionNode(at: CGPoint(x: 50, y: 0))
        }
    }

}
