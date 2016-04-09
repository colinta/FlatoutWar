//
//  BaseLevel9.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel9: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel9Config() }
    override func goToNextWorld() {
        director?.presentWorld(BaseLevelSelectWorld())
    }

    override func populateLevel() {
        moveCamera(to: CGPoint(150, 50), duration: 2)
        beginWave1(at: 4)
    }

    func beginWave1(at delay: CGFloat) {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        timeline.at(.After(delay), block: generateEnemyColumn(rand(min: -size.angle, max: TAU_4)))
        timeline.at(.After(delay + 15), block: generateEnemyColumn(rand(min: -size.angle, max: TAU_4)))
        timeline.at(.After(delay + 28), block: generateEnemyColumn(rand(min: -size.angle, max: TAU_4)))
        timeline.at(.After(delay + 28), block: nextStep())
    }

    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        timeline.every(6...8, start: .Delayed(), times: 4) {
            let angle: CGFloat = rand(min: -self.size.angle, max: TAU_4)
            self.generateBigJetWithFollowers(angle, spread: 0)()
        } ~~> nextStep()
    }

    func beginWave3() {
        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(200, 75), zoom: 0.75, duration: 3)
        }
        timeline.at(.Delayed(3), block: generateGiant(size.angle))
        timeline.at(.Delayed(4), block: generateGiant(size.angle - TAU_16))
        timeline.at(.Delayed(4.75), block: generateGiant(size.angle + TAU_16))
        timeline.every(1.5...2.5, start: .Delayed(), times: 10, block: generateEnemy(rand(±size.angle)))
    }

    func generateEnemyColumn(screenAngle: CGFloat) -> Block {
        return {
            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

            let numPairs = 10
            var r: CGFloat = 0
            let dist: CGFloat = 5
            for _ in 0..<numPairs {
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
                    enemy.name = "pair soldier"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(ghost)
                    self << enemy
                }
            }
        }
    }

}
