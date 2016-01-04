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
        let wave1_weak_1: CGFloat = randSideAngle()
        let wave1_weak_2: CGFloat = wave1_weak_1 ± rand(TAU_8)
        let wave1_strong_1 = wave1_weak_1 + TAU_2 ± rand(TAU_16)
        timeline.every(1.5...3.0, startAt: 3, times: 10, block: self.generateEnemy(wave1_weak_1))
        timeline.every(1.5...3.0, startAt: 3, times: 10, block: self.generateEnemy(wave1_weak_2))
        timeline.every(3...6, startAt: 3, times: 5, block: self.generateLeaderEnemy(wave1_strong_1))
        timeline.every(1.5...3, startAt: 3, times: 10, block: self.generateEnemy(wave1_strong_1, spread: TAU_8))

        timeline.at(25) {
            self.moveCamera(to: CGPoint(x: 100, y: 0))
        }
    }

}
