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

        let closeButton = CloseButton()
        closeButton.onTapped { _ in
            self.director?.presentWorld(TutorialSelectWorld())
        }
        ui << closeButton
    }

    override func worldShook() {
        super.worldShook()
        if timeRate == 0.25 { timeRate = 1 }
        else { timeRate = 0.25 }
    }

}
