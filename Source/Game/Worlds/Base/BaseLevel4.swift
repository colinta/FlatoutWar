//
//  BaseLevel4.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4: Level {

    override func loadConfig() -> BaseConfig { return BaseLevel4Config() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        timeline.every(12, times: 8) {
            let xs: CGFloat = ±1
            let start = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: self.size.height / 2 + 40
                )
            let dest = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: -start.y
                )
            self.generateWarning(start.angle)
            self.timeline.after(3) {
                let transport = EnemyJetTransportNode()
                var control = (start + dest) / 2
                if start.x > 0 {
                    control += CGPoint(x: self.size.height / 4)
                }
                else {
                    control -= CGPoint(x: self.size.height / 4)
                }

                let arcTo = transport.arcTo(dest, start: start, duration: 10)
                arcTo.control = control
                arcTo.onArrived {
                    transport.removeFromParent()
                }

                transport.transportPayload([
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemyLeaderNode(),
                ])

                self << transport
            }
        } ~~> nextStep()
    }

    func beginWave2() {
        moveCamera(to: CGPoint(x: 180, y: 0), duration: 2)
    }

}
