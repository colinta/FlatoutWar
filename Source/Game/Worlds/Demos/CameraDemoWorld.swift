//
//  CameraDemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class CameraDemoWorld: DemoWorld {

    override func populateWorld() {
        super.populateWorld()

        let cameraNode = EnemySoldierNode()
        cameraNode.rammingComponent?.enabled = false
        cameraNode.enemyComponent?.targetable = false
        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 250
        wanderingComponent.centeredAround = .zero
        wanderingComponent.maxSpeed = 25
        cameraNode.addComponent(wanderingComponent)
        self << cameraNode
        self.cameraNode = cameraNode

        setScale(2)
        let zoomingComponent1 = ScaleToComponent()
        zoomingComponent1.target = 1.0
        zoomingComponent1.rate = 0.25

        timeline.at(1) {
            self.addComponent(zoomingComponent1)
        }
    }

}
