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
            customizeNode(node)
            self << node
        }

        beginWave1(at: 4)
        beginWave2(at: 45)
        moveCamera(to: CGPoint(150, 50), duration: 2)
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel5()
    }

    func beginWave1(at startTime: CGFloat) {
        timeline.every(0.39, startAt: startTime, times: 10, block: generateEnemyPair(rand(TAU * 3 / 8)))
        timeline.every(0.39, startAt: startTime + 15, times: 10, block: generateEnemyPair(rand(TAU * 3 / 8)))
        timeline.every(0.39, startAt: startTime + 25, times: 10, block: generateEnemyPair(rand(TAU * 3 / 8)))
    }

    func beginWave2(at startTime: CGFloat) {
    }

}
