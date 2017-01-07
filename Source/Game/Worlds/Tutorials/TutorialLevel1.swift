////
///  TutorialLevel1.swift
//

class TutorialLevel1: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel1Config() }

    override func populateLevel() {
        beginWave1()
    }

    // two sources of weak enemies
    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        generateWarning(wave1, wave2)
        timeline.every(1.5...2.5, start: .Delayed(), times: 15, block: self.generateEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...4, start: .Delayed(), times: 10, block: self.generateEnemy(wave2)) ~~> nextStep()
    }

    // one source of weak, one source of strong
    func beginWave2() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave3() }
        }

        let wave2_leader = size.angle
        let wave2_soldier: CGFloat = -size.angle ± rand(TAU_16)
        generateWarning(wave2_leader, wave2_soldier)
        timeline.every(3...5, start: .Delayed(), times: 5, block: self.generateLeaderEnemy(wave2_leader)) ~~> nextStep()
        timeline.every(1.5...3.0, start: .Delayed(1), times: 10, block: self.generateEnemy(wave2_soldier)) ~~> nextStep()
    }

    // random
    func beginWave3() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave4() }
        }

        10.times { (i: Int) in
            generateWarning(TAU * CGFloat(i) / 10)
        }
        timeline.every(1...2.5, start: .Delayed(), times: 10) {
            self.generateEnemy(rand(TAU), constRadius: true)()
        } ~~> nextStep()
    }

    // four sources of weak enemies
    func beginWave4() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave5() }
        }

        let wave1 = randSideAngle()
        let wave2 = wave1 ± rand(min: 10.degrees, max: 20.degrees)
        let wave3 = wave1 ± (TAU_4 - rand(TAU_16))
        let wave4 = wave3 ± rand(min: 10.degrees, max: 20.degrees)
        generateWarning(wave1, wave2, wave3, wave4)
        timeline.every(3...5, start: .Delayed(), times: 6, block: self.generateEnemy(wave1)) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(), times: 6, block: self.generateEnemy(wave2)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(3), times: 5, block: self.generateEnemy(wave3)) ~~> nextStep()
        timeline.every(3...6, start: .Delayed(3), times: 5, block: self.generateEnemy(wave4)) ~~> nextStep()
    }

    // four sources of weak enemies
    func beginWave5() {
        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_4 - rand(TAU_8)
        let wave3 = wave1 - TAU_4 + rand(TAU_8)
        let wave4 = wave1 ± rand(TAU_8)
        generateWarning(wave1, wave2, wave3, wave4)
        timeline.every(3...4, start: .Delayed(), times: 4, block: self.generateEnemy(wave1))
        timeline.every(2...3, start: .Delayed(5), times: 4, block: self.generateEnemy(wave2))
        timeline.every(2, start: .Delayed(10), times: 4, block: self.generateEnemy(wave3))
        timeline.every(1, start: .Delayed(15), times: 6, block: self.generateEnemy(wave4))
    }

}
