//
//  TutorialLevel5.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel5: TutorialLevel {

    override func loadConfig() -> BaseConfig { return TutorialLevel5Config() }

    override func populateLevel() {
        timeline.after(1) {
            self.introduceDrone()
        }

        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1: CGFloat = ±rand(TAU_8)
        let wave2: CGFloat = wave1 ± rand(min: TAU_16, max: TAU_8)
        let wave3 = TAU_2 ± rand(TAU_16)
        generateWarning(wave1, wave2, wave3 - TAU_4, wave3, wave3 + TAU_4)

        timeline.every(1.5...3.0, start: .Delayed(), times: 10, block: generateEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...3.0, start: .Delayed(), times: 10, block: generateEnemy(wave2)) ~~> nextStep()

        timeline.every(3...6, start: .Delayed(), times: 5, block: generateLeaderEnemy(wave3, spread: TAU_16)) ~~> nextStep()
        timeline.every(1.5...3, start: .Delayed(), times: 10, block: generateEnemy(wave3, spread: TAU_4)) ~~> nextStep()
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(x: -120, y: 0), duration: 3)
        }

        let wave1 = TAU_2 + rand(TAU_16)
        let wave2 = TAU_2 - rand(TAU_16)
        timeline.at(.Delayed(1)) {
            self.generateWarning(wave1, wave2)
        }
        timeline.every(0.5, start: .Delayed(4), times: 20) {
            self.generateEnemy(wave1, spread: TAU_16)()
        } ~~> nextStep()
        timeline.every(0.5, start: .Delayed(10), times: 20) {
            self.generateEnemy(wave2, spread: TAU_16)()
        } ~~> nextStep()
    }

    func beginWave3() {
        let wave1 = TAU_2
        let wave2 = ±TAU_4
        let wave3 = TAU_2
        generateWarning(wave1)

        timeline.every(0.5, start: .Delayed(), times: 20, block: generateJet(wave1, spread: 20))
        timeline.at(.Delayed(9)) {
            self.generateWarning(wave2, wave3)
        }
        timeline.every(0.5, start: .Delayed(12), times: 20, block: generateJet(wave2, spread: 20))
        timeline.every(0.4, start: .Delayed(12), times: 20, block: generateJet(wave3, spread: 20))
    }

}
