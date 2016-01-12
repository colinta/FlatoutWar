//
//  BaseLevel1.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel1: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel1Config() }
    override func tutorial() -> Tutorial { return AutoFireTutorial() }

    override func populateWorld() {
        super.populateWorld()

        playerNode.overrideForceFire = false

        beginWave1(at: 3)
        beginWave2(at: 35)
        beginWave3(at: 62)
        beginWave4(at: 95)
        beginWave5(at: 125)
    }

    // two sources of weak enemies
    func beginWave1(at startTime: CGFloat) {
        let wave1_1: CGFloat = rand(TAU)
        let wave1_2 = wave1_1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        timeline.every(1.5...2.5, startAt: startTime, times: 15, block: self.generateEnemy(wave1_1))
        timeline.every(1.5...4, startAt: startTime, times: 10, block: self.generateEnemy(wave1_2))
    }

    // one source of weak, one source of strong
    func beginWave2(at startTime: CGFloat) {
        let wave2_leader = size.angle
        let wave2_soldier: CGFloat = -size.angle ± rand(TAU_16)
        timeline.every(3...5, startAt: startTime, times: 5, block: self.generateLeaderEnemy(wave2_leader))
        timeline.every(1.5...3.0, startAt: startTime + 1, times: 10, block: self.generateEnemy(wave2_soldier))
    }

    // random
    func beginWave3(at startTime: CGFloat) {
        timeline.every(0.5...2, startAt: startTime, times: 20) {
            self.generateEnemy(rand(TAU), constRadius: true)()
        }
    }

    // two waves of formations
    func beginWave4(at startTime: CGFloat) {
        timeline.at(startTime, block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(startTime + 15, block: self.generateEnemyFormation(randSideAngle()))
    }

    // three sources of weak enemies
    func beginWave5(at startTime: CGFloat) {
        let wave4_1: CGFloat = rand(TAU)
        let wave4_2 = wave4_1 + TAU_4 - rand(TAU_8)
        let wave4_3 = wave4_1 - TAU_4 + rand(TAU_8)
        let wave4_4 = wave4_1 ± rand(TAU_8)
        timeline.every(3...4, startAt: startTime, times: 4, block: self.generateEnemy(wave4_1))
        timeline.every(2...3, startAt: startTime + 5, times: 4, block: self.generateEnemy(wave4_2))
        timeline.every(2, startAt: startTime + 10, times: 4, block: self.generateEnemy(wave4_3))
        timeline.every(1, startAt: startTime + 15, times: 6, block: self.generateEnemy(wave4_4))
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel2()
    }

}
