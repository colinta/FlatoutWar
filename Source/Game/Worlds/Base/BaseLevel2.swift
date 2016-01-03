//
//  BaseLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2: BaseLevel {
    override func populateWorld() {
        super.populateWorld()

        // wave 1: one sources of weak enemies in a wave
        let wave1 = TAU_2 ± rand(size.angle)
        var spread = CGFloat(2.5)
        var div = CGFloat(0.5)
        timeline.every(0.45, startAt: 0, times: 40) {
            let angle = wave1 + spread.degrees * sin(self.timeline.time / div)
            self.generateEnemy(angle, spread: 0)()
            spread += 0.3
            div /= 0.99
        }

        // wave 2: Dozers
        let wave2 = self.randSideAngle()
        timeline.every(4...6, startAt: 28, times: 5, block: self.generateDozers(wave2, spread: TAU_8))

        // wave 3: wide waves
        timeline.every(6, startAt: 60, times: 8) {
            let angle: CGFloat = self.randSideAngle()
            let delta = 5.degrees
            for i in 0..<5 {
                let myAngle = angle + CGFloat(i - 2) * delta
                self.timeline.after(CGFloat(i) * 0.1, block: self.generateEnemy(myAngle, spread: 0))
            }
        }

        // wave 4: fast enemies waves
        timeline.every(6, startAt: 80, times: 5) {
            self.generateScoutEnemies(self.randSideAngle())()
        }
        timeline.every(2, startAt: 115, times: 5) {
            self.generateScoutEnemies(self.randSideAngle())()
        }

        // wave 5: fast enemies waves
        let wave5 = self.randSideAngle()
        timeline.every(1, startAt: 130, times: 10, block: self.generateScoutEnemies(wave5, spread: TAU_8))

        // success
        timeline.at(126) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }
}
