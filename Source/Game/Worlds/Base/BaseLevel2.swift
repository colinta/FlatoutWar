//
//  BaseLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel2Config() }

    override func populateWorld() {
        super.populateWorld()

        playerNode.forceFireEnabled = false

        beginWave1(at: 4)
    }

    // two sources of weak enemies
    func beginWave1(at delay: CGFloat) {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1_1: CGFloat = rand(TAU)
        let wave1_2 = wave1_1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        timeline.every(3.5...5.5, start: .After(delay), times: 6, block: self.generateLeaderEnemy(wave1_1)) ~~> nextStep()
        timeline.every(3.5...5.5, start: .After(delay + 4.5), times: 5, block: self.generateLeaderEnemy(wave1_2)) ~~> nextStep()
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave2_1: CGFloat = rand(TAU)
        let wave2_2: CGFloat = wave2_1 ± TAU_4 ± rand(TAU_8)
        timeline.at(.Delayed(3), block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(.Delayed(25), block: self.generateEnemyFormation(randSideAngle()))
        timeline.every(3...5, start: .Delayed(), times: 10, block: self.generateEnemy(wave2_2)) ~~> nextStep()
    }

    func beginWave3() {
        let wave3_1: CGFloat = randSideAngle()
        let wave3_2: CGFloat = wave3_1 ± rand(TAU_16)
        timeline.at(.Delayed(), block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(.Delayed(11), block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(.Delayed(23), block: self.generateEnemyFormation(wave3_1))
        timeline.every(1, start: .Delayed(34), times: 11, block: self.generateEnemy(wave3_2))
        timeline.at(.Delayed(45), block: self.generateEnemyFormation(randSideAngle()))
    }

    func generateEnemyFormation(screenAngle: CGFloat)() {
        let dist: CGFloat = 25
        let enemyLeader = EnemyLeaderNode()
        enemyLeader.name = "formation leader"
        let center = outsideWorld(extra: enemyLeader.radius + dist * 1.5, angle: screenAngle)
        enemyLeader.position = center
        enemyLeader.rotateTowards(point: .Zero)
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
