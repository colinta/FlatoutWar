//
//  BaseLevel4.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel4Config() }
    override func tutorial() -> Tutorial { return RapidFireTutorial() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel5()
    }

    override func populateWorld() {
        super.populateWorld()

        beginWave1(at: 3)
        beginWave2(at: 32)
        beginWave3(at: 60)
        beginWave4(at: 80)
        beginWave5(at: 130)
    }

    // one sources of weak enemies in a wave
    func beginWave1(at startTime: CGFloat) {
        let wave1 = TAU_2 ± rand(size.angle)
        var spread = CGFloat(2.5)
        timeline.every(0.45, startAt: startTime, times: 40) {
            let angle = wave1 + rand(spread.degrees)

            let enemyNode = EnemySoldierNode()
            enemyNode.position = CGPoint(r: self.outerRadius, a: angle)
            self << enemyNode
            spread += 0.75
        }
    }

    // Dozers
    func beginWave2(at startTime: CGFloat) {
        let wave2 = self.randSideAngle()
        timeline.every(4...6, startAt: startTime, times: 5, block: self.generateDozer(wave2, spread: TAU_8))
    }

    // wide waves
    func beginWave3(at startTime: CGFloat) {
        timeline.every(6, startAt: startTime, times: 8) {
            let angle: CGFloat = self.randSideAngle()
            let delta = 5.degrees
            for i in 0..<5 {
                let myAngle = angle + CGFloat(i - 2) * delta
                self.timeline.after(CGFloat(i) * 0.1, block: self.generateEnemy(myAngle, spread: 0))
            }
        }
    }

    // fast enemies waves
    func beginWave4(at startTime: CGFloat) {
        timeline.every(6, startAt: startTime, times: 5) {
            self.generateScouts(self.randSideAngle())()
        }
        timeline.every(2, startAt: startTime + 35, times: 5) {
            self.generateScouts(self.randSideAngle())()
        }
    }

    // fast enemies waves
    func beginWave5(at startTime: CGFloat) {
        let wave5 = self.randSideAngle()
        timeline.every(1, startAt: startTime, times: 10, block: self.generateScouts(wave5, spread: TAU_8))
    }

    func generateDozer(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
            screenAngle = screenAngle ± rand(spread)
        }
        let enemyCount = 4
        let height: CGFloat = CGFloat(enemyCount * 12) + 2
        let dozer = EnemyDozerNode()
        dozer.name = "dozer"
        dozer.position = outsideWorld(dozer, angle: screenAngle)
        dozer.rotateTowards(point: CGPointZero)
        self << dozer

        let min = -height / 2 + 5
        let max = height / 2 - 5
        for i in 0..<enemyCount {
            let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
            let location = dozer.position + CGPoint(r: 10, a: screenAngle) + CGPoint(r: r, a: screenAngle + 90.degrees)
            let enemy = EnemySoldierNode(at: location)
            enemy.name = "dozer soldier"
            enemy.rotateTo(dozer.zRotation)
            enemy.follow(dozer, scatter: false)
            self << enemy
        }
    }

}
