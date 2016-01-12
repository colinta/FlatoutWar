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

        let soldier = EnemySoldierNode()
        soldier.position = CGPoint(-250, 0)
        soldier.name = "leader"
        self << soldier

        let enemy = EnemyLeaderNode(at: CGPoint(-300, 0))
        enemy.name = "follower"
        self << enemy
        enemy.follow(soldier)
    }

}
