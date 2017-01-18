////
///  TutorialLevel4.swift
//

class TutorialLevel4: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel4Config() }

    override func populateWorld() {
        super.populateWorld()
        disableRapidFire()
    }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    // quads and pairs of enemies (48)
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        generateWarning(wave1)

        timeline.every(9...11, start: .Delayed(), times: 6) {
            let angle: CGFloat = wave1 + TAU_2 ± rand(TAU_4)
            self.generateWarning(angle)
            self.timeline.at(.Delayed(), block: self.generateEnemyQuad(angle)) ~~> nextStep()
        } ~~> nextStep()
        timeline.every(3...5, start: .Delayed(), times: 12,
            block: generateEnemyPair(wave1)) ~~> nextStep()
    }

    // Leader w/ linear followers, scouts, and soldiers (56)
    func beginWave2(nextStep: @escaping NextStepBlock) {
        timeline.every(8...10, times: 4) {
            let wave = self.randSideAngle(.Right)
            self.generateWarning(wave)
            self.timeline.at(.Delayed(), block: self.generateLeaderWithLinearFollowers(wave))
        } ~~> nextStep()

        timeline.every(5...7, start: .Delayed(), times: 6) {
            let angle: CGFloat = rand(TAU)
            self.generateWarning(angle)
            self.timeline.at(.Delayed(), block: self.generateScouts(angle))
        } ~~> nextStep()

        timeline.every(5...7, start: .Delayed(2), times: 6) {
            let angle: CGFloat = rand(TAU)
            self.generateWarning(angle)
            self.timeline.at(.Delayed(), block: self.generateEnemy(angle))
        } ~~> nextStep()
    }

    // fast soldiers (26)
    func beginWave3(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2: CGFloat = wave1 + rand(TAU_3)
        let wave3: CGFloat = wave1 - rand(TAU_3)
        generateWarning(wave1, wave2, wave3)

        timeline.every(3...5, start: .Delayed(), times: 9, block: generateFastEnemy(wave1)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(2), times: 8, block: generateFastEnemy(wave2)) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(4), times: 9, block: generateFastEnemy(wave3)) ~~> nextStep()
    }

    func generateEnemyPair(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(mimic: EnemySoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

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
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyQuad(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: EnemySoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let dist: CGFloat = 5.5
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
                enemy.name = "quad soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

}
