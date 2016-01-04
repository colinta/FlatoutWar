//
//  BaseLevel1.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel1: BaseLevel {
    override func populateWorld() {
        super.populateWorld()

        playerNode.overrideForceFire = false

        // wave 1: two sources of weak enemies
        let wave1_1: CGFloat = rand(TAU)
        let wave1_2 = wave1_1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        timeline.every(1.5...2.5, startAt: 3, times: 15, block: self.generateEnemy(wave1_1))
        timeline.every(1.5...4, startAt: 3, times: 10, block: self.generateEnemy(wave1_2))

        // wave 2: one source of weak, one source of strong
        let wave2_1: CGFloat = rand(TAU)
        let wave2_2 = wave2_1 + TAU_4 ± rand(TAU_8)
        timeline.every(1.5...3.0, startAt: 35, times: 10, block: self.generateEnemy(wave2_1))
        timeline.every(3...5, startAt: 35, times: 5, block: self.generateLeaderEnemy(wave2_2))

        // wave: random
        timeline.every(0.5...2, startAt: 60, times: 20) {
            self.generateEnemy(rand(TAU))()
        }

        // wave 3: two waves of formations
        timeline.at(90, block: self.generateEnemyFormation(rand(TAU)))
        timeline.at(105, block: self.generateEnemyFormation(rand(TAU)))

        // wave 4: three sources of weak enemies
        let wave4_1: CGFloat = rand(TAU)
        let wave4_2 = wave4_1 + TAU_4 - rand(TAU_8)
        let wave4_3 = wave4_1 - TAU_4 + rand(TAU_8)
        let wave4_4 = wave4_1 ± rand(TAU_8)
        timeline.every(3...4, startAt: 120, times: 4, block: self.generateEnemy(wave4_1))
        timeline.every(2...3, startAt: 125, times: 4, block: self.generateEnemy(wave4_2))
        timeline.every(2, startAt: 130, times: 4, block: self.generateEnemy(wave4_3))
        timeline.every(1, startAt: 135, times: 4, block: self.generateEnemy(wave4_4))

        // success
        timeline.when({ self.possibleExperience >= 100 }) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }

    override func goToNextLevel() {
        director?.presentWorld(RapidFireTutorial())
    }

}
