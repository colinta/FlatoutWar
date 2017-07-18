////
///  OceanLevel1.swift
//

// starts with the "sin wave" of enemies, wave 2 is dozers from one angle,
// wave 3 is 8 wide enemy waves, wave 4 is a bunch of scouts, wave 5 is even
// MORE scouts, but from only one side, and wave 6 is all out scouts, slow
// enemies, and dozers

class OceanLevel1: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel1Config() }

    override func populateLevel() {
        linkWaves(
            // beginWave1,
            beginWave2,
            beginWave3,
            beginWave4,
            beginWave5,
            beginWave6
            )
    }

    // one sources of weak enemies in a wave
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle(.right)
        generateWarning(
            wave1 - 15.degrees,
            wave1,
            wave1 + 15.degrees
        )
        var spread = CGFloat(2.5)
        timeline.every(0.41, start: .Delayed(), times: 40) {
            let angle = wave1 + rand(spread.degrees)

            let enemyNode = EnemySoldierNode()
            enemyNode.position = CGPoint(r: self.outerRadius + 20 + enemyNode.radius, a: angle)
            self << enemyNode
            spread += 0.75
        } ~~> nextStep()
    }

    // Dozers
    func beginWave2(nextStep: @escaping NextStepBlock) {
    }

    // wide waves
    func beginWave3(nextStep: @escaping NextStepBlock) {
        timeline.every(6, times: 8) {
            let angle: CGFloat = self.randSideAngle()
            let delta = 5.degrees
            self.generateWarning(angle, angle - delta, angle + delta)
            self.timeline.at(.Delayed()) {
                for i in 0..<5 {
                    let myAngle = angle + CGFloat(i - 2) * delta
                    self.timeline.after(time: CGFloat(i) * 0.1,
                        block: self.generateEnemy(myAngle, spread: 0, constRadius: true)) ~~> nextStep()
                }
            } ~~> nextStep()
        } ~~> nextStep()
    }

    // fast enemies waves
    func beginWave4(nextStep: @escaping NextStepBlock) {
        generateBothSidesWarnings()

        timeline.every(4, start: .Delayed(), times: 5,
            block: generateScouts(self.randSideAngle())) ~~> nextStep()
        timeline.every(2, start: .Delayed(20), times: 5,
            block: generateScouts(self.randSideAngle())) ~~> nextStep()
    }

    // fast enemies waves
    func beginWave5(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle()
        let spread = TAU_8
        generateWarning(wave1, wave1 - spread, wave1 + spread)
        timeline.every(1, start: .Delayed(), times: 10,
            block: generateScouts(wave1, spread: spread)) ~~> nextStep()
    }

    // onslaught
    func beginWave6(nextStep: @escaping NextStepBlock) {
    }
}
