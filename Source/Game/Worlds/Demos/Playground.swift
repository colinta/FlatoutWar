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

        let drone = DroneNode(at: CGPoint(100, 50))
        drone.draggableComponent?.maintainDistance(100, around: playerNode)
        self << drone

        let soldier = EnemySoldierNode()
        soldier.position = outsideWorld(soldier, angle: TAU_2)
        self << soldier

        timeline.every(0.5, startAt: 3) {
            let jet = EnemyJetNode()
            jet.position = self.outsideWorld(jet, angle: TAU_2)
            self << jet
        }
    }

}
