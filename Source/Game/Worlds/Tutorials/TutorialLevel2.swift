////
///  TutorialLevel2.swift
//

class TutorialLevel2: TutorialLevel {

    override func loadConfig() -> BaseConfig { return TutorialLevel2Config() }

    override func populateLevel() {
        beginWave1()

        var delay: CGFloat = 2
        8.times { (i: Int) in
            timeline.at(.Delayed(delay), block: generateResourceArc())
            delay += 15
        }
    }

    // two sources of weak enemies (40)
    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        var delay: CGFloat = 0
        5.times { (i: Int) in
            let after = nextStep()
            timeline.at(.Delayed(delay)) {
                let wave: CGFloat = rand(TAU)
                self.generateWarning(wave)
                self.timeline.at(.Delayed(), block: self.generateEnemyFormation(wave) ++ after)
            }
            delay += 10
        }
    }

    // random (10)
    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        10.times { (i: Int) in
            generateWarning(TAU * CGFloat(i) / 10)
        }
        timeline.every(1...2.5, start: .Delayed(), times: 12) {
            self.generateEnemy(rand(TAU), constRadius: true)()
        } ~~> nextStep()
    }

    // three sources of weak enemies (20)
    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        let wave1 = randSideAngle(.Right)
        let wave2 = wave1 + rand(min: 10.degrees, max: 20.degrees)
        let wave3 = randSideAngle(.Left)
        generateWarning(wave1, wave2, wave3)
        timeline.every(1...5, start: .Delayed(), times: 8,
            block: generateEnemy(wave1)) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(), times: 8,
            block: generateEnemy(wave2)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(3), times: 7,
            block: generateEnemy(wave3)) ~~> nextStep()
    }

    // 5 bursts of enemies (10)
    func beginWave4() {
        timeline.every(7, times: 5) {
            let wave: CGFloat = rand(TAU)
            self.generateWarning(wave)
            self.timeline.at(.Delayed(), block: self.generateScouts(wave))
        }
        timeline.every(6...8, times: 5) {
            let wave: CGFloat = rand(TAU)
            self.generateWarning(wave)
            self.timeline.at(.Delayed()) {
                var radius: CGFloat = 0
                let position = self.outsideWorld(EnemySoldierNode(), angle: wave)
                let angle = self.playerNode.position.angleTo(position)
                4.times {
                    let enemyNode = EnemySoldierNode()
                    enemyNode.name = "soldier"
                    enemyNode.position = position + CGPoint(r: radius, a: angle)
                    self << enemyNode
                    radius += 2 * enemyNode.radius
                }
            }
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
