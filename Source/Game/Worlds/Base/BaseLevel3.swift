//
//  BaseLevel3.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel3: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel3Config() }
    override func tutorial() -> Tutorial { return DroneTutorial() }

    override func populateWorld() {
        super.populateWorld()

        timeline.after(1) {
            self.introduceDrone()
        }

        beginWave1(at: 3)
        beginWave2(at: 35)
        beginWave3(at: 72)
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel4()
    }

    func beginWave1(at startTime: CGFloat) {
        let wave1_weak_1: CGFloat = ±rand(TAU_8)
        let wave1_weak_2: CGFloat = wave1_weak_1 ± rand(min: TAU_16, max: TAU_8)
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: generateEnemy(wave1_weak_1))
        timeline.every(1.5...3.0, startAt: startTime, times: 10, block: generateEnemy(wave1_weak_2))

        let wave1_strong_1 = TAU_2 ± rand(TAU_16)
        timeline.every(3...6, startAt: startTime, times: 5, block: generateLeaderEnemy(wave1_strong_1, spread: TAU_16))
        timeline.every(1.5...3, startAt: startTime, times: 10, block: generateEnemy(wave1_strong_1, spread: TAU_4))
    }

    func beginWave2(at startTime: CGFloat) {
        timeline.at(startTime) {
            self.moveCamera(to: CGPoint(x: -120, y: 0), duration: 3)
        }
        let wave2_1 = TAU_2 + rand(TAU_16)
        let wave2_2 = TAU_2 - rand(TAU_16)
        timeline.every(0.5, startAt: startTime + 4, times: 20, block: generateEnemy(wave2_1, spread: TAU_16))
        timeline.every(0.5, startAt: startTime + 10, times: 20, block: generateEnemy(wave2_2, spread: TAU_16))
    }

    func beginWave3(at startTime: CGFloat) {
        timeline.every(0.5, startAt: startTime, times: 20, block: generateJet(TAU_2, spread: 20))
        timeline.every(0.5, startAt: startTime + 12, times: 20, block: generateJet(±TAU_4, spread: 20))
        timeline.every(0.4, startAt: startTime + 12, times: 20, block: generateJet(TAU_2, spread: 20))
    }

}
