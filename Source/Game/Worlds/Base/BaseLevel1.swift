//
//  BaseLevel1.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel1: BaseLevel {
    override func loadConfig() -> BaseConfig { return BaseLevel1Config() }

    override func populateLevel() {
        beginWave1()
    }

    // one sources of weak enemies in a wave
    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1 = TAU_2 ± rand(size.angle)
        generateWarning(
            wave1 - 15.degrees,
            wave1,
            wave1 + 15.degrees
        )
        var spread = CGFloat(2.5)
        timeline.every(0.45, start: .Delayed(), times: 40) {
            let angle = wave1 + rand(spread.degrees)

            let enemyNode = EnemySoldierNode()
            enemyNode.position = CGPoint(r: self.outerRadius + 20 + enemyNode.radius, a: angle)
            self << enemyNode
            spread += 0.75
        } ~~> nextStep()
    }

    // Dozers
    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave1 = self.randSideAngle()
        generateWarning(wave1 - TAU_16)
        generateWarning(wave1 + TAU_16)
        timeline.every(4...6, start: .Delayed(), times: 5, block: self.generateDozer(wave1, spread: TAU_8)) ~~> nextStep()
    }

    // wide waves
    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        timeline.every(6, times: 8) {
            let angle: CGFloat = self.randSideAngle()
            let delta = 5.degrees
            self.generateWarning(angle, angle - delta, angle + delta)
            self.timeline.at(.Delayed()) {
                for i in 0..<5 {
                    let myAngle = angle + CGFloat(i - 2) * delta
                    self.timeline.after(CGFloat(i) * 0.1, block: self.generateEnemy(myAngle, spread: 0, constRadius: true))
                }
            }
        } ~~> nextStep()
    }

    // fast enemies waves
    func beginWave4() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave5() }
        }

        let angles = [
            -size.angle * 7 / 8,
            -size.angle / 2,
            0,
            size.angle / 2,
            size.angle * 7 / 8,
        ]
        for angle in angles {
            generateWarning(angle, TAU_2 + angle)
        }
        timeline.every(6, start: .Delayed(), times: 5) {
            self.generateScouts(self.randSideAngle())()
        } ~~> nextStep()
        timeline.every(2, start: .Delayed(35), times: 5) {
            self.generateScouts(self.randSideAngle())()
        } ~~> nextStep()
    }

    // fast enemies waves
    func beginWave5() {
        let wave5 = self.randSideAngle()
        let spread = TAU_8
        self.generateWarning(wave5, wave5 - spread, wave5 + spread)
        timeline.every(1, start: .Delayed(), times: 10, block: self.generateScouts(wave5, spread: spread))
    }

    func generateDozer(genScreenAngle: CGFloat, spread: CGFloat) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyCount = 4
            let height: CGFloat = CGFloat(enemyCount * 12) + 2
            let dozer = EnemyDozerNode()
            dozer.name = "dozer"
            dozer.position = self.outsideWorld(dozer, angle: screenAngle)
            dozer.rotateTowards(point: .zero)
            self << dozer

            let min = -height / 2 + 5
            let max = height / 2 - 5
            for i in 0..<enemyCount {
                let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
                let location = dozer.position + CGPoint(r: 10, a: screenAngle) + CGPoint(r: r, a: screenAngle + 90.degrees)
                let enemy = EnemySoldierNode(at: location)
                enemy.name = "dozer soldier"
                enemy.rotateTo(dozer.zRotation)
                enemy.follow(dozer, scatter: .None)
                self << enemy
            }
        }
    }

}
