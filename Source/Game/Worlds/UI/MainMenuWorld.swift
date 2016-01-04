//
//  MainMenuWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class MainMenuWorld: World {

    override func populateWorld() {
        pauseable = false

        let textNode = TextNode(at: CGPoint(x: 0, y: 100))
        textNode.text = "FLATOUT WAR"
        self << textNode

        let enemyNode = EnemySoldierNode(at: CGPoint(x: -200, y: 0))
        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 50
        wanderingComponent.centeredAround = enemyNode.position
        wanderingComponent.maxSpeed = 10
        enemyNode.addComponent(wanderingComponent)
        self << enemyNode

        let startButtonNode = Button(at: CGPoint(x: 0, y: 0))
        startButtonNode.text = "START"
        startButtonNode.onTapped {
            self.director?.presentWorld(LevelSelectWorld())
        }
        self << startButtonNode

        let setupButtonNode = Button(at: CGPoint(x: 0, y: -60))
        setupButtonNode.text = "SETUP"
        setupButtonNode.onTapped {
            self.director?.presentWorld(StartupWorld())
        }
        self << setupButtonNode
    }
}
