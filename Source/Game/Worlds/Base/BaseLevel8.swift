//
//  BaseLevel8.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel8: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel8Config() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        timeline.every(12, start: 3) {
            let transport = EnemyJetTransportNode()
            let xs: CGFloat = ±1
            let start = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: self.size.height / 2 + 40
                )
            let dest = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: -start.y
                )
            var control = (start + dest) / 2
            if start.x > 0 {
                control += CGPoint(x: self.size.height / 4)
            }
            else {
                control -= CGPoint(x: self.size.height / 4)
            }

            let arcTo = transport.arcTo(dest, duration: 10, start: start)
            arcTo.control = control
            arcTo.onArrived {
                transport.removeFromParent()
            }
            self << transport

            transport.transportPayload([
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                ])
        }
    }

    func beginWave2() {
    }

}
