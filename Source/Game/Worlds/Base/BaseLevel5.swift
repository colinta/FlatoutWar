//
//  BaseLevel5.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel5: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel5Config() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        timeline.every(0.5, start: .Delayed(), times: 100, block: generateEnemy(0))
    }

    func beginWave2() {
    }

}
