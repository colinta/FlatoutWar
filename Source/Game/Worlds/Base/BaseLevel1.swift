//
//  BaseLevel1.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel1: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel1Config() }

    override func populateWorld() {
        super.populateWorld()

        playerNode.forceFireEnabled = false

        beginWave1()
    }

    // two sources of weak enemies
    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1_1: CGFloat = rand(TAU)
        let wave1_2 = wave1_1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        timeline.every(1.5...2.5, start: .Delayed(), times: 15, finally: nextStep(), block: self.generateEnemy(wave1_1))
        timeline.every(1.5...4, start: .Delayed(), times: 10, finally: nextStep(), block: self.generateEnemy(wave1_2))
    }

    // one source of weak, one source of strong
    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave2_leader = size.angle
        let wave2_soldier: CGFloat = -size.angle ± rand(TAU_16)
        timeline.every(3...5, start: .Delayed(), times: 5, finally: nextStep(), block: self.generateLeaderEnemy(wave2_leader))
        timeline.every(1.5...3.0, start: .Delayed(1), times: 10, finally: nextStep(), block: self.generateEnemy(wave2_soldier))
    }

    // random
    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        timeline.every(0.5...2, start: .Delayed(), times: 20, finally: nextStep()) {
            self.generateEnemy(rand(TAU), constRadius: true)()
        }
    }

    // four sources of weak enemies
    func beginWave4() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave5() }
        }

        let wave4_1: CGFloat = randSideAngle()
        let wave4_2 = wave4_1 ± rand(min: 10.degrees, max: 20.degrees)
        let wave4_3 = wave4_1 ± (TAU_4 - rand(TAU_16))
        let wave4_4 = wave4_3 ± rand(min: 10.degrees, max: 20.degrees)
        timeline.every(3...5, start: .Delayed(), times: 6, finally: nextStep(), block: {
            self.generateEnemy(wave4_1)()
            self.generateEnemy(wave4_2)()
        })
        timeline.every(3...6, start: .Delayed(3), times: 5, finally: nextStep()) {
            self.generateEnemy(wave4_3)()
            self.generateEnemy(wave4_4)()
        }
    }

    // four sources of weak enemies
    func beginWave5() {
        let wave5_1: CGFloat = rand(TAU)
        let wave5_2 = wave5_1 + TAU_4 - rand(TAU_8)
        let wave5_3 = wave5_1 - TAU_4 + rand(TAU_8)
        let wave5_4 = wave5_1 ± rand(TAU_8)
        timeline.every(3...4, start: .Delayed(), times: 4, block: self.generateEnemy(wave5_1))
        timeline.every(2...3, start: .Delayed(5), times: 4, block: self.generateEnemy(wave5_2))
        timeline.every(2, start: .Delayed(10), times: 4, block: self.generateEnemy(wave5_3))
        timeline.every(1, start: .Delayed(15), times: 6, block: self.generateEnemy(wave5_4))
    }

}
