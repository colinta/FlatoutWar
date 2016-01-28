//
//  BaseLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel2Config() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel3()
    }

    override func populateWorld() {
        super.populateWorld()

        playerNode.forceFireEnabled = false

        beginWave1(at: 4)
        beginWave2(at: 37)
        beginWave3(at: 83)
    }

    // two sources of weak enemies
    func beginWave1(at startTime: CGFloat) {
        let wave1_1: CGFloat = rand(TAU)
        let wave1_2 = wave1_1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        timeline.every(3.5...5.5, startAt: startTime, times: 6, block: self.generateLeaderEnemy(wave1_1))
        timeline.every(3.5...5.5, startAt: startTime + 4.5, times: 5, block: self.generateLeaderEnemy(wave1_2))
    }

    func beginWave2(at startTime: CGFloat) {
        let wave2_1: CGFloat = rand(TAU)
        let wave2_2: CGFloat = wave2_1 ± TAU_4 ± rand(TAU_8)
        timeline.at(startTime + 3, block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(startTime + 25, block: self.generateEnemyFormation(randSideAngle()))
        timeline.every(3...5, startAt: startTime, times: 10, block: self.generateEnemy(wave2_2))
    }

    func beginWave3(at startTime: CGFloat) {
        let wave3_1: CGFloat = randSideAngle()
        let wave3_2: CGFloat = wave3_1 ± rand(TAU_16)
        timeline.at(startTime, block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(startTime + 11, block: self.generateEnemyFormation(randSideAngle()))
        timeline.at(startTime + 23, block: self.generateEnemyFormation(wave3_1))
        timeline.every(1, startAt: startTime + 34, times: 11, block: self.generateEnemy(wave3_2))
        timeline.at(startTime + 45, block: self.generateEnemyFormation(randSideAngle()))
    }

    func generateEnemyFormation(screenAngle: CGFloat)() {
        let dist: CGFloat = 25
        let enemyLeader = EnemyLeaderNode()
        enemyLeader.name = "formation leader"
        let center = outsideWorld(extra: enemyLeader.radius + dist * 1.5, angle: screenAngle)
        enemyLeader.position = center
        enemyLeader.rotateTowards(point: CGPointZero)
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
