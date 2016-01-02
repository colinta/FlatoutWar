//
//  CameraDemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class CameraDemoWorld: World {

    override func populateWorld() {
        super.populateWorld()

        let playerNode = BasePlayerNode()
        playerNode.targetingComponent?.enabled = false
        defaultNode = playerNode
        self << playerNode

        let cameraNode = EnemySoldierNode()
        cameraNode.rammingComponent?.enabled = false
        cameraNode.addComponent(RotateToComponent())
        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 250
        wanderingComponent.centeredAround = CGPointZero
        wanderingComponent.maxSpeed = 25
        cameraNode.addComponent(wanderingComponent)
        self << cameraNode
        self.cameraNode = cameraNode

        setScale(2)
        let zoomingComponent1 = ZoomToComponent()
        zoomingComponent1.target = 1.0

        timeline.at(1) {
            self.addComponent(zoomingComponent1)
        }
    }

}
