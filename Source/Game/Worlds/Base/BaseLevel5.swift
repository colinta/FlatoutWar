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

        timeline.every(4.5...7, start: .Delayed(), times: 8) {
            let angle = self.randSideAngle()
            self.generateLeaderEnemy(angle, spread: 0)()
            3.times {
                self.generateScouts(angle)()
            }
        } ~~> nextStep()
    }

    func beginWave2() {
        timeline.every(3.5...5.5, start: .Delayed(), times: 13) {
            self.generateEnemy(rand(TAU))()
        }
        timeline.every(3.5...5, start: .Delayed(), times: 10) {
            self.generateScouts(rand(TAU))()
        }
        timeline.every(6.5, start: .Delayed(3), times: 5) {
            self.generateSlowEnemy(rand(TAU))()
        }
    }

}
