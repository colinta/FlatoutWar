//
//  BaseLevel5.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/25/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel5: Level {

    override func loadConfig() -> BaseConfig { return BaseLevel5Config() }
    override func goToNextWorld() {
        director?.presentWorld(WorldSelectWorld(beginAt: .Base))
    }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        timeline.every(2, times: 2) {
            self.generateEnemy(0)()
        } ~~> nextStep()
    }

    func beginWave2() {
        // moveCamera(to: CGPoint(x: 180, y: 0), duration: 2)
    }

}
