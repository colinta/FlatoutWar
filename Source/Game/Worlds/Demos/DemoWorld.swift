//
//  DemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DemoWorld: World {
    let playerNode = BasePlayerNode()

    override func populateWorld() {
        pauseable = false

        defaultNode = playerNode
        self << playerNode

        let closeButton = Button(fixed: .TopRight(x: -15, y: -15))
        closeButton.setScale(0.5)
        closeButton.text = "×"
        closeButton.size = CGSize(60)
        closeButton.onTapped { _ in
            self.director?.presentWorld(LevelSelectWorld())
        }
        ui << closeButton
    }

}
