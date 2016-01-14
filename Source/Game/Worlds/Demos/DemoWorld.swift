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

        let restartButton = Button()
        restartButton.fixedPosition = .TopLeft(x: 15, y: -15)
        restartButton.setScale(0.5)
        restartButton.font = .Small
        restartButton.size = CGSize(60)
        restartButton.text = "O"
        restartButton.onTapped { _ in
            self.restartWorld()
        }
        ui << restartButton
    }

    override func worldShook() {
        super.worldShook()
        if timeRate == 0.5 { timeRate = 1 }
        else { timeRate = 0.5 }
    }

}
