//
//  TutorialLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TutorialLevel2: TutorialLevel {

    override func loadConfig() -> BaseConfig { return TutorialLevel2Config() }

    override func populateLevel() {
        beginWave1()
    }

    // two sources of weak enemies
    func beginWave1() {
        let nextStep = afterN {
            // self.onNoMoreEnemies { self.beginWave2() }
        }

        var delay: CGFloat = 0
        5.times { (i: Int) in
            timeline.at(.Delayed(delay)) {
                let wave: CGFloat = rand(TAU)
                self.generateWarning(wave)
                self.timeline.after(3, block: self.generateEnemyFormation(wave))

                let resourceNode = ResourceNode(goal: 20)
                let a: CGFloat = rand(TAU)
                let p1 = self.outsideWorld(resourceNode, angle: a)
                let p2 = self.outsideWorld(resourceNode, angle: a + TAU_2)
                let vector = (p2 - p1) / 3
                let arcTo = resourceNode.arcTo(
                    p2,
                    start: p1,
                    speed: 100
                    )
                arcTo.control = vector + CGPoint(r: vector.length, a: vector.angle + TAU_4)
                arcTo.control2 = 2 * vector + CGPoint(r: vector.length, a: vector.angle - TAU_4)
                self << resourceNode
            }
            delay += 10
        }
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

            let origins = [
                center + left,
                center + right,
                back + left,
                back,
                back + right,
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
