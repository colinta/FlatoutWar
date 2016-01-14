//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: DemoWorld {

    override func populateWorld() {
        super.populateWorld()
        timeRate = 1
        playerNode.position = CGPoint(0, -20)
        playerNode.enabled = false

        let n = SKShapeNode(circleOfRadius: 3)
        n.position = CGPoint(245, -4)
        self << n

        let soldier = EnemySoldierNode()
        soldier.position = CGPoint(250, 0)
        soldier.rammingComponent?.tempTarget = n.position
        soldier.name = "soldier"
        soldier.rotateTowards(point: CGPointZero)
        self << soldier

        let m = SKShapeNode(circleOfRadius: 3)
        m.position = CGPoint(240, 80)
        self << m

        let jet = EnemyJetNode()
        jet.position = CGPoint(250, 100)
        jet.rammingComponent?.tempTarget = m.position
        jet.name = "Jet"
        jet.rotateTowards(point: CGPointZero)
        self << jet
    }

}
