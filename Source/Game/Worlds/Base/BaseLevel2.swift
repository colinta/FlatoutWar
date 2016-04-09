//
//  BaseLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel2Config() }

    override func populateLevel() {
        beginWave1()
    }

    // two sources of weak enemies
    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        generateWarning(wave1)
        generateWarning(wave2)
        timeline.every(3.5...5.5, start: .Delayed(), times: 6, block: self.generateSlowEnemy(wave1)) ~~> nextStep()
        timeline.every(3.5...5.5, start: .Delayed(4.5), times: 5, block: self.generateSlowEnemy(wave2)) ~~> nextStep()
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        generateWarning(wave1)
        generateWarning(wave2)
        timeline.every(1.5...3.5, start: .Delayed(), times: 3, block: self.generateSlowEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...3.5, start: .Delayed(), times: 2, block: self.generateSlowEnemy(wave2)) ~~> nextStep()
    }

    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        let wave1: CGFloat = rand(TAU)
        let wave2 = randSideAngle()
        let wave3 = randSideAngle()
        generateWarning(wave1)
        timeline.every(6...10, start: .Delayed(), times: 5, block: self.generateSlowEnemy(wave1)) ~~> nextStep()

        timeline.at(.Delayed()) { self.generateWarning(wave2) }
        timeline.at(.Delayed(3), block: self.generateEnemyFormation(wave2))

        timeline.at(.Delayed(22)) { self.generateWarning(wave3) }
        timeline.at(.Delayed(25), block: self.generateEnemyFormation(wave3) + nextStep())
    }

    func beginWave4() {
        let wave1 = randSideAngle()
        let wave2 = randSideAngle()
        let wave3 = randSideAngle()
        let wave4 = wave3 ± TAU_8
        let wave5 = randSideAngle()

        generateWarning(wave1)
        timeline.at(.Delayed(), block: self.generateEnemyFormation(wave1))

        timeline.at(.Delayed(8)) { self.generateWarning(wave2) }
        timeline.at(.Delayed(11), block: self.generateEnemyFormation(wave2))

        timeline.at(.Delayed(20)) { self.generateWarning(wave3) }
        timeline.at(.Delayed(23), block: self.generateEnemyFormation(wave3))

        timeline.at(.Delayed(31)) { self.generateWarning(wave4) }
        timeline.every(2, start: .Delayed(34), times: 12) {
            self.generateEnemy(wave4, spread: TAU_8)()
        }

        timeline.at(.Delayed(55)) { self.generateWarning(wave5) }
        timeline.at(.Delayed(58), block: self.generateEnemyFormation(wave5))
    }

    func generateEnemyFormation(screenAngle: CGFloat) -> Block {
        return {
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            enemyLeader.name = "formation leader"
            let center = self.outsideWorld(extra: enemyLeader.radius + dist * 1.5, angle: screenAngle)
            enemyLeader.position = center
            enemyLeader.rotateTowards(point: .zero)
            self << enemyLeader

            let angle = center.angle
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)
            let back = center + CGVector(r: dist, a: angle)
            let back2 = center + CGVector(r: 2 * dist, a: angle)

            let origins = [
                center + left,
                center + right,
                back + left,
                back,
                back + right,
                back2 + left,
                back2,
                back2 + right,
            ]
            for origin in origins {
                let enemy = EnemySoldierNode(at: origin)
                enemy.name = "formation soldier"
                enemy.rotateTo(enemyLeader.zRotation)
                enemy.follow(enemyLeader)
                self << enemy
            }
        }
    }

}
