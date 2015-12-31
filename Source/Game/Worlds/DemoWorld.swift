//
//  DemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DemoWorld: World {

    override func populate() {
        let playerNode = BasePlayerNode()
        defaultNode = playerNode
        self << playerNode

        let drone = DroneNode(at: CGPoint(100, 50))
        self << drone

        timeRate = 1
        let count = 1
        let radius = CGFloat(200)
        for angleIndex in 0...count {
            let angle = TAU * CGFloat(angleIndex) / CGFloat(count)
            let enemyNode = SoldierNode(at: CGPoint(r: radius, a: angle))
            enemyNode.rotateTowards(node: playerNode)
            self << enemyNode
        }
    }

}
