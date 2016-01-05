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
    }

    func beginWave1(at startTime: CGFloat) {
        let wave1_weak_1: CGFloat = TAU_2 ± rand(TAU_8)
        let wave1_weak_2: CGFloat = wave1_weak_1 ± rand(min: TAU_16, max: TAU_8)
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: self.generateEnemy(wave1_weak_1))
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: self.generateEnemy(wave1_weak_2))

        let wave1_strong_1 = ±rand(TAU_16)
        timeline.every(3...6, startAt: startTime, times: 5, block: self.generateLeaderEnemy(wave1_strong_1, spread: TAU_16))
        timeline.every(1.5...3, startAt: startTime, times: 10, block: self.generateEnemy(wave1_strong_1, spread: TAU_4))
    }

    func beginWave2(at startTime: CGFloat) {
        timeline.at(startTime) {
            self.moveCamera(to: CGPoint(x: -100, y: 0), zoom: 0.75, duration: 3)
        }
        let wave2 = TAU_2 ± rand(TAU_16)
        timeline.every(4, startAt: startTime + 5, times: 5, block: self.generateLeaderWithCircularFollowers(wave2, spread: TAU_16))
    }

}
