////
///  TutorialLevel2.swift
//

class TutorialLevel2: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel2Config() }

    override func populateWorld() {
        super.populateWorld()
        disableRapidFire()
    }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3, beginWave4)
    }

    // three sources of weak enemies (20)
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle(.Right)
        let wave2 = wave1 ± rand(min: 10.degrees, max: 15.degrees)
        let wave3 = randSideAngle(.Left)
        generateWarning(wave1, wave2, wave3)
        timeline.every(1...5, start: .Delayed(), times: 8,
            block: generateEnemy(wave1)) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(), times: 8,
            block: generateEnemy(wave2)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(3), times: 7,
            block: generateEnemy(wave3)) ~~> nextStep()
    }

    // two sources of weak enemies (40)
    func beginWave2(nextStep: @escaping NextStepBlock) {
        var delay: CGFloat = 0
        5.times { (i: Int) in
            timeline.at(.Delayed(delay)) {
                let wave: CGFloat = rand(TAU)
                self.generateWarning(wave)
                self.timeline.at(.Delayed(), block: self.generateEnemyFormation(wave)) ~~> nextStep()
            }
            delay += 10
        }
    }

    // random (10)
    func beginWave3(nextStep: @escaping NextStepBlock) {
        generateAllSidesWarnings()

        timeline.every(2...4, start: .Delayed(), times: 13,
            block: generateEnemy(rand(TAU), constRadius: true)) ~~> nextStep()
        timeline.every(12...14, start: .Delayed(), times: 3,
            block: generateLeaderEnemy(rand(TAU), constRadius: true)) ~~> nextStep()
    }

    // 5 bursts of enemies (10)
    func beginWave4(nextStep: @escaping NextStepBlock) {
        timeline.every(7, times: 5) {
            let wave: CGFloat = rand(TAU)
            self.generateWarning(wave)
            self.timeline.at(.Delayed(), block: self.generateScouts(wave)) ~~> nextStep()
        } ~~> nextStep()

        timeline.every(6...8, times: 5) {
            let wave: CGFloat = rand(TAU)
            self.generateWarning(wave)
            self.timeline.at(.Delayed()) {
                var radius: CGFloat = 0
                let position = self.outsideWorld(node: EnemySoldierNode(), angle: wave)
                let angle = self.playerNode.position.angleTo(position)
                4.times {
                    let enemyNode = EnemySoldierNode()
                    enemyNode.position = position + CGPoint(r: radius, a: angle)
                    self << enemyNode
                    radius += 2 * enemyNode.radius
                }
            } ~~> nextStep()
        } ~~> nextStep()
    }

    func generateEnemyFormation(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            enemyLeader.name = "formation \(enemyLeader.nodeName)"
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
                back + right,
            ]
            for origin in origins {
                let enemy = EnemySoldierNode(at: origin)
                enemy.name = "formation \(enemy.nodeName)"
                enemy.rotateTo(enemyLeader.zRotation)
                enemy.follow(leader: enemyLeader)
                self << enemy
            }
        }
    }

}
