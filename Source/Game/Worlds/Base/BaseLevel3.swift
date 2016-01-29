//
//  BaseLevel3.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel3: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel3Config() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel4()
    }

    override func populateWorld() {
        super.populateWorld()

        playerNode.forceFireEnabled = false

        self.moveCamera(to: CGPoint(x: 180, y: 0), duration: 2)
        beginWave1(at: 4)
        beginWave2(at: 25)
        beginWave3(at: 51)
        beginWave4(at: 97)
    }

    func beginWave1(at startTime: CGFloat) {
        let wave1_1 = randSideAngle(.Right)
        let wave1_2 = wave1_1 ± (TAU_16 + rand(TAU_16))
        timeline.every(0.5...2.5, startAt: startTime, times: 5, block: generateEnemyPair(wave1_1))
        timeline.every(0.5...2.5, startAt: startTime + 3, times: 4, block: generateEnemyPair(wave1_2))
    }

    func beginWave2(at startTime: CGFloat) {
        let wave2_1 = randSideAngle(.Right)
        let wave2_2 = wave2_1 ± (TAU_8 + rand(TAU_16))
        timeline.every(2...5, startAt: startTime, times: 5, block: generateEnemyTrio(wave2_1))
        timeline.every(3...6, startAt: startTime + 4, times: 4, block: generateEnemyTrio(wave2_2))
    }

    func beginWave3(at startTime: CGFloat) {
        timeline.every(3...7, startAt: startTime, times: 5) {
            let wave3_1 = self.randSideAngle(.Right)
            self.generateLeaderWithLinearFollowers(wave3_1)()
        }
    }

    func beginWave4(at startTime: CGFloat) {
        var trios = 7
        var quads = 6
        timeline.every(1...5, startAt: startTime, until: { return trios == 0 && quads == 0 }) {
            let pickTrio = [true, false].randWeighted { $0 ? Float(trios) : Float(quads) }
            if pickTrio == true {
                trios -= 1
                self.generateEnemyTrio(self.randSideAngle(.Right))()
            }
            else if pickTrio == false {
                quads -= 1
                self.generateEnemyQuad(self.randSideAngle(.Right))()
            }
        }
    }

    func generateEnemyPair(screenAngle: CGFloat)() {
        let dist: CGFloat = 5.5
        let ghost = generateEnemyGhost(angle: screenAngle, extra: 10)
        ghost.name = "pair ghost"
        ghost.rotateTowards(point: CGPointZero)

        let angle = ghost.position.angle
        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)

        let origins = [
            ghost.position + left,
            ghost.position + right,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.name = "pair soldier"
            enemy.rotateTo(ghost.zRotation)
            enemy.follow(ghost)
            self << enemy
        }
    }

    func generateEnemyTrio(screenAngle: CGFloat)() {
        let dist: CGFloat = 5.5
        let ghost = generateEnemyGhost(angle: screenAngle, extra: 10)
        ghost.name = "pair ghost"
        ghost.rotateTowards(point: CGPointZero)

        let angle = ghost.position.angle
        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)
        let back = CGVector(r: dist * 2, a: angle)

        let origins = [
            ghost.position + left,
            ghost.position + right,
            ghost.position + back,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.name = "pair soldier"
            enemy.rotateTo(ghost.zRotation)
            enemy.follow(ghost)
            self << enemy
        }
    }

    func generateEnemyQuad(screenAngle: CGFloat)() {
        let dist: CGFloat = 5.5
        let ghost = generateEnemyGhost(angle: screenAngle, extra: 10)
        ghost.name = "pair ghost"
        ghost.rotateTowards(point: CGPointZero)

        let angle = ghost.position.angle
        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)
        let back = CGVector(r: dist * 2, a: angle)

        let origins = [
            ghost.position + left,
            ghost.position + right,
            ghost.position + left + back,
            ghost.position + right + back,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.name = "pair soldier"
            enemy.rotateTo(ghost.zRotation)
            enemy.follow(ghost)
            self << enemy
        }
    }

}
