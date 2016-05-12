//
//  TutorialLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TutorialLevel2: TutorialLevel {

    override func loadConfig() -> BaseConfig { return TutorialLevel2Config() }

    override func populateLevel() {
        beginWave1()
    }

    // two sources of weak enemies
    func beginWave1() {
        let nextStep = afterN {
            // self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        generateWarning(wave1, wave2)
        timeline.every(1.5...2.5, start: .Delayed(), times: 15, block: self.generateEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...4, start: .Delayed(), times: 10, block: self.generateEnemy(wave2)) ~~> nextStep()
    }

}
