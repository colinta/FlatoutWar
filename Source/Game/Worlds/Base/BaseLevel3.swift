//
//  BaseLevel3.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel3: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel3Config() }

    override func populateLevel() {
        moveCamera(to: CGPoint(x: 180, y: 0), duration: 2)
        beginWave1(at: 4)
    }

    func beginWave1(at delay: CGFloat) {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1_1 = randSideAngle(.Right)
        let wave1_2 = wave1_1 ± (TAU_16 + rand(TAU_16))
        timeline.every(0.5...2.5, start: .After(delay), times: 5, block: generateEnemyPair(wave1_1)) ~~> nextStep()
        timeline.every(0.5...2.5, start: .After(delay + 3), times: 4, block: generateEnemyPair(wave1_2)) ~~> nextStep()
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave2_1 = randSideAngle(.Right)
        let wave2_2 = wave2_1 ± (TAU_8 + rand(TAU_16))
        timeline.every(2...5, start: .Delayed(), times: 5, block: generateEnemyTrio(wave2_1)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(4), times: 4, block: generateEnemyTrio(wave2_2)) ~~> nextStep()
    }

    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        timeline.every(3...7, start: .Delayed(), times: 5) {
            let wave3_1 = self.randSideAngle(.Right)
            self.generateLeaderWithLinearFollowers(wave3_1)()
        } ~~> nextStep()
    }

    func beginWave4() {
        var trios = 7
        var quads = 6
        timeline.every(1...5, start: .Delayed(), until: { return trios == 0 && quads == 0 }) {
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

    func generateEnemyPair(screenAngle: CGFloat) -> Block {
        return {
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

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
    }

    func generateEnemyTrio(screenAngle: CGFloat) -> Block {
        return {
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

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
    }

    func generateEnemyQuad(screenAngle: CGFloat) -> Block {
        return {
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

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

}
