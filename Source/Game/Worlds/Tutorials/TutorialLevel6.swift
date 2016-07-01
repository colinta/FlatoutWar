//
//  TutorialLevel6.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel6: TutorialLevel {
    override func loadConfig() -> BaseConfig { return TutorialLevel6Config() }

    override func populateLevel() {
        shouldReturnToLevelSelect = true

        moveCamera(to: CGPoint(150, 50), duration: 2)
        beginWave1(at: 4)

        var delay: CGFloat = 3
        9.times { (i: Int) in
            timeline.at(.Delayed(delay), block: generateResourceArc())
            delay += 10
        }
    }

    func beginWave1(at delay: CGFloat) {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }
        let randAngle: () -> CGFloat = { return rand(min: -self.size.angle, max: TAU_4) }

        let delays: [CGFloat] = [
            0, 12, 22
        ]
        for delay in delays {
            let wave1 = randAngle()
            let wave2 = randAngle()
            timeline.at(.After(delay)) {
                self.generateWarning(wave1, wave2)
            }
            timeline.at(.Delayed(delay)) {
                self.generateEnemyColumn(wave1)()
                self.generateEnemyColumn(wave2)()
            }
        }
        timeline.at(.Delayed(delays.last!), block: nextStep())
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        self.generateWarning(0, TAU_16, -TAU_16)
        timeline.every(7...9, start: .Delayed(), times: 4) {
            let angle: CGFloat = self.randSideAngle(.Right)
            self.generateBigJetWithFollowers(angle, spread: 0)()
        } ~~> nextStep()
    }

    func beginWave3() {
        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(200, 75), zoom: 0.75, duration: 3)
        }
        timeline.at(.Delayed(3), block: generateGiant(size.angle))
        timeline.at(.Delayed(6), block: generateGiant(size.angle - TAU_16))
        timeline.at(.Delayed(10), block: generateGiant(size.angle + TAU_16))

        let wave1 = randSideAngle(.Right)
        let wave2 = randSideAngle(.Bottom)
        self.generateWarning(wave1, wave2)
        timeline.every(1.5...2.5, start: .Delayed(), times: 10, block: generateEnemy(wave1))
        timeline.every(1.5...2.5, start: .Delayed(), times: 10, block: generateEnemy(wave2))
    }

    func generateEnemyColumn(screenAngle: CGFloat) -> Block {
        return {
            let ghost = self.generateEnemyGhost(mimic: EnemySoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

            let numPairs = 5
            var r: CGFloat = 0
            let dist: CGFloat = 5
            numPairs.times {
                let angle = ghost.position.angle
                let left = CGVector(r: dist, a: angle + TAU_4) + CGVector(r: r, a: angle)
                let right = CGVector(r: dist, a: angle - TAU_4) + CGVector(r: r, a: angle)
                r += 2 * dist

                let origins = [
                    ghost.position + left,
                    ghost.position + right,
                ]
                for origin in origins {
                    let enemy = EnemySoldierNode(at: origin)
                    enemy.name = "soldier"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(ghost)
                    self << enemy
                }
            }
        }
    }

    func generateGiant(screenAngle: CGFloat) -> Block {
        return {
            let enemyNode = EnemyGiantNode()
            enemyNode.name = "giant"
            enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

}
