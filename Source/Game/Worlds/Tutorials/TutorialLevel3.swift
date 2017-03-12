////
///  TutorialLevel3.swift
//

class TutorialLevel3: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel3Config() }

    override func populateWorld() {
        super.populateWorld()
        disableRapidFire()
    }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3, beginWave4)
    }

    // two sources of weak enemies
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2: CGFloat = wave1 ± rand(TAU_12)
        let wave3 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        let wave4 = wave3 ± rand(TAU_12)
        generateWarning((wave1+wave2) / 2, (wave3+wave4) / 2)
        timeline.every(4...6, start: .Delayed(), times: 6,
            block: generateSlowEnemy(wave1)) ~~> nextStep()
        timeline.every(4...6, start: .Delayed(), times: 6,
            block: generateEnemy(wave2)) ~~> nextStep()
        timeline.every(3.5...6.5, start: .Delayed(4.5), times: 5,
            block: generateSlowEnemy(wave3)) ~~> nextStep()
        timeline.every(3.5...6.5, start: .Delayed(4.5), times: 5,
            block: generateEnemy(wave4)) ~~> nextStep()
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2: CGFloat = wave1 ± rand(TAU_12)
        let wave3 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        let wave4 = wave3 ± rand(TAU_12)
        generateWarning((wave1+wave2) / 2, (wave3+wave4) / 2)
        timeline.every(1.5...3.5, start: .Delayed(), times: 3,
            block: generateSlowEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...3.5, start: .Delayed(), times: 3,
            block: generateScouts(wave2)) ~~> nextStep()
        timeline.every(1.5...3.5, start: .Delayed(), times: 2,
            block: generateSlowEnemy(wave3)) ~~> nextStep()
        timeline.every(1.5...3.5, start: .Delayed(), times: 2,
            block: generateScouts(wave4)) ~~> nextStep()
    }

    func beginWave3(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        generateWarning(wave1)
        timeline.every(6...10, start: .Delayed(), times: 5, block: generateSlowEnemy(wave1)) ~~> nextStep()

        let wave2 = randSideAngle()
        timeline.at(.Delayed()) { self.generateWarning(wave2) }
        timeline.at(.Delayed(3), block: generateEnemyFormation(wave2))

        let wave3 = randSideAngle()
        timeline.at(.Delayed(22)) { self.generateWarning(wave3) }
        timeline.at(.Delayed(25), block: generateEnemyFormation(wave3)) ~~> nextStep()
    }

    func beginWave4(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle()

        generateWarning(wave1)
        timeline.at(.Delayed(), block: self.generateEnemyFormation(wave1))

        let wave2 = randSideAngle()
        timeline.at(.Delayed(8)) { self.generateWarning(wave2) }
        timeline.at(.Delayed(11), block: self.generateEnemyFormation(wave2))

        let wave3 = randSideAngle()
        timeline.at(.Delayed(20)) { self.generateWarning(wave3) }
        timeline.at(.Delayed(23), block: self.generateEnemyFormation(wave3))

        let wave4 = wave3 ± TAU_8
        timeline.at(.Delayed(31)) {
            self.generateWarning(wave4 - TAU_12, wave4, wave4 + TAU_12)
        }
        timeline.every(2, start: .Delayed(34), times: 12, block: generateEnemy(wave4, spread: TAU_8))

        let wave5 = randSideAngle()
        timeline.at(.Delayed(55)) { self.generateWarning(wave5) }
        timeline.at(.Delayed(58), block: generateEnemyFormation(wave5)) ~~> nextStep()
    }

    func generateEnemyFormation(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            enemyLeader.name = "formation \(enemyLeader.name)"
            let center = self.outsideWorld(extra: enemyLeader.radius + dist * 1.5, angle: screenAngle)
            enemyLeader.position = center
            enemyLeader.rotateTowards(point: .zero)
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
                enemy.name = "formation \(enemy.name)"
                enemy.rotateTo(enemyLeader.zRotation)
                enemy.follow(leader: enemyLeader)
                self << enemy
            }
        }
    }

}
