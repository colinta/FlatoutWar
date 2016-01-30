//
//  BaseLevel7.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel7: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel7Config() }

    override func populateWorld() {
        super.populateWorld()

        timeline.after(1) {
            self.introduceDrone()
        }

        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1_weak_1: CGFloat = ±rand(TAU_8)
        let wave1_weak_2: CGFloat = wave1_weak_1 ± rand(min: TAU_16, max: TAU_8)
        timeline.every(1.5...3.0, start: .Delayed(), times: 10, finally: nextStep(), block: generateEnemy(wave1_weak_1))
        timeline.every(1.5...3.0, start: .Delayed(), times: 10, finally: nextStep(), block: generateEnemy(wave1_weak_2))

        let wave1_strong_1 = TAU_2 ± rand(TAU_16)
        timeline.every(3...6, start: .Delayed(), times: 5, finally: nextStep(), block: generateLeaderEnemy(wave1_strong_1, spread: TAU_16))
        timeline.every(1.5...3, start: .Delayed(), times: 10, finally: nextStep(), block: generateEnemy(wave1_strong_1, spread: TAU_4))
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(x: -120, y: 0), duration: 3)
        }
        let wave2_1 = TAU_2 + rand(TAU_16)
        let wave2_2 = TAU_2 - rand(TAU_16)
        timeline.every(0.5, start: .Delayed(4), times: 20, finally: nextStep()) {
            self.generateEnemy(wave2_1, spread: TAU_16)()
        }
        timeline.every(0.5, start: .Delayed(10), times: 20, finally: nextStep()) {
            self.generateEnemy(wave2_2, spread: TAU_16)()
        }
    }

    func beginWave3() {
        timeline.every(0.5, start: .Delayed(), times: 20, block: generateJet(TAU_2, spread: 20))
        timeline.every(0.5, start: .Delayed(12), times: 20, block: generateJet(±TAU_4, spread: 20))
        timeline.every(0.4, start: .Delayed(12), times: 20, block: generateJet(TAU_2, spread: 20))
    }

}
