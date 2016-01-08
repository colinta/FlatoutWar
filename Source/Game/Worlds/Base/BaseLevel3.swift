//
//  BaseLevel3.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel3: BaseLevel {

    override func populateWorld() {
        super.populateWorld()

        timeline.after(1) {
            self.introduceDrone()
        }

        // wave 1: two sources of weak, one source of strong
        beginWave1(at: 3)
        beginWave2(at: 35)
        beginWave3(at: 75)
        timeline.at(100) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }

    override func goToNextLevel() {
        director?.presentWorld(BaseLevel4())
    }

    func beginWave1(at startTime: CGFloat) {
        let wave1_weak_1: CGFloat = ±rand(TAU_8)
        let wave1_weak_2: CGFloat = wave1_weak_1 ± rand(min: TAU_16, max: TAU_8)
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: self.generateEnemy(wave1_weak_1))
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: self.generateEnemy(wave1_weak_2))

        let wave1_strong_1 = TAU_2 ± rand(TAU_16)
        timeline.every(3...6, startAt: startTime, times: 5, block: self.generateLeaderEnemy(wave1_strong_1, spread: TAU_16))
        timeline.every(1.5...3, startAt: startTime, times: 10, block: self.generateEnemy(wave1_strong_1, spread: TAU_4))
    }

    func beginWave2(at startTime: CGFloat) {
        timeline.at(startTime) {
            self.moveCamera(to: CGPoint(x: -120, y: 0), zoom: 0.75, duration: 3)
        }
        let wave2_1 = TAU_2 + rand(TAU_16)
        let wave2_2 = TAU_2 - rand(TAU_16)
        timeline.every(0.5, startAt: startTime + 4, times: 20, block: self.generateEnemy(wave2_1, spread: TAU_16))
        timeline.every(0.5, startAt: startTime + 10, times: 20, block: self.generateEnemy(wave2_2, spread: TAU_16))
    }

    func beginWave3(at startTime: CGFloat) {
        timeline.every(0.5, startAt: startTime, times: 20) {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(jet, angle: TAU_2) + CGPoint(y: ±rand(20))
            self << jet
        }
        let jetAngle = ±TAU_4
        timeline.every(0.5, startAt: startTime + 12, times: 20) {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(jet, angle: jetAngle) + CGPoint(y: ±rand(20))
            self << jet
        }
        timeline.every(0.4, startAt: startTime + 12, times: 20) {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(jet, angle: TAU_2) + CGPoint(y: ±rand(20))
            self << jet
        }
    }

}
