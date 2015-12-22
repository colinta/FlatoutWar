//
//  DemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DemoWorld: World {

    override func populate() {
        super.populate()

        let playerNode = BasePlayerNode()
        self << playerNode
        let count = 30
        let radius = CGFloat(50)
        for angleIndex in 0...count {
            let myRadius = radius + CGFloat(5 * angleIndex)
            let angle = TAU * CGFloat(angleIndex) / CGFloat(count)
            timeline.after(CGFloat(angleIndex) / 15) {
                let enemyNode = SoldierNode(at: CGPoint(r: myRadius, a: angle))
                enemyNode.rotateTowards(node: playerNode)
                self << enemyNode
            }
        }
    }

}
