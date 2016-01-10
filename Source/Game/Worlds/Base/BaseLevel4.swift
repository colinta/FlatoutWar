//
//  BaseLevel4.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel4Config() }
    override func tutorial() -> Tutorial { return DroneTutorial() }

    override func populateWorld() {
        super.populateWorld()

        for node in config.storedPlayers {
            self << node
        }

        beginWave1(at: 3)
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel5()
    }

    func beginWave1(at startTime: CGFloat) {
        timeline.every(1, startAt: startTime) {
        }
    }

}
