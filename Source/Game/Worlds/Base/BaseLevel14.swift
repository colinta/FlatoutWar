//
//  BaseLevel14.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel14: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel14Config() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        _ = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }
    }

    func beginWave2() {
    }

}
