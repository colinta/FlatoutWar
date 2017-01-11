////
///  BaseLevel1.swift
//

// starts with the "sin wave" of enemies, wave 2 is dozers from one angle,
// wave 3 is 8 wide enemy waves, wave 4 is a bunch of scouts, wave 5 is even
// MORE scouts, but from only one side, and wave 6 is all out scouts, slow
// enemies, and dozers

class BaseLevel1: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel1Config() }

    override func populateLevel() {
        linkWaves(
            beginWave1,
            beginWave2,
            beginWave3,
            beginWave4,
            beginWave5,
            beginWave6
            )
    }

    // one sources of weak enemies in a wave
    func beginWave1(nextStep: NextStepBlock) {
        let wave1 = TAU_2 ± rand(size.angle)
        generateWarning(
            wave1 - 15.degrees,
            wave1,
            wave1 + 15.degrees
        )
        var spread = CGFloat(2.5)
        timeline.every(0.45, start: .Delayed(), times: 40) {
            let angle = wave1 + rand(spread.degrees)

            let enemyNode = EnemySoldierNode()
            enemyNode.position = CGPoint(r: self.outerRadius + 20 + enemyNode.radius, a: angle)
            self << enemyNode
            spread += 0.75
        } ~~> nextStep()
    }

    // Dozers
    func beginWave2(nextStep: NextStepBlock) {
        let wave1 = self.randSideAngle()
        generateWarning(wave1 - TAU_16)
        generateWarning(wave1 + TAU_16)
        timeline.every(4...6, start: .Delayed(), times: 5, block: self.generateDozer(wave1, spread: TAU_8)) ~~> nextStep()
    }

    // wide waves
    func beginWave3(nextStep: NextStepBlock) {
        timeline.every(6, times: 8) {
            let angle: CGFloat = self.randSideAngle()
            let delta = 5.degrees
            self.generateWarning(angle, angle - delta, angle + delta)
            self.timeline.at(.Delayed()) {
                for i in 0..<5 {
                    let myAngle = angle + CGFloat(i - 2) * delta
                    self.timeline.after(time: CGFloat(i) * 0.1, block: self.generateEnemy(myAngle, spread: 0, constRadius: true))
                }
            }
        } ~~> nextStep()
    }

    // fast enemies waves
    func beginWave4(nextStep: NextStepBlock) {
        generateBothSidesWarnings()

        timeline.every(4, start: .Delayed(), times: 5) {
            self.generateScouts(self.randSideAngle())()
        } ~~> nextStep()
        timeline.every(2, start: .Delayed(20), times: 5) {
            self.generateScouts(self.randSideAngle())()
        } ~~> nextStep()
    }

    // fast enemies waves
    func beginWave5(nextStep: NextStepBlock) {
        let wave1 = self.randSideAngle()
        let spread = TAU_8
        self.generateWarning(wave1, wave1 - spread, wave1 + spread)
        timeline.every(1, start: .Delayed(), times: 10, block: self.generateScouts(wave1, spread: spread)
            ) ~~> nextStep()
    }

    // onslaught
    func beginWave6(nextStep: NextStepBlock) {
        timeline.every(4...6, start: .Delayed(), times: 7, block: { self.generateScouts(rand(TAU))() }) ~~> nextStep()
        timeline.every(6...8, start: .Delayed(), times: 5, block: { self.generateSlowEnemy(rand(TAU))() }) ~~> nextStep()
        timeline.every(8...10, start: .Delayed(), times: 4, block: { self.generateDozer(rand(TAU))() }) ~~> nextStep()
    }

    func generateDozer(_ genScreenAngle: CGFloat, spread: CGFloat = 0) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyCount = 4
            let height: CGFloat = CGFloat(enemyCount * 12) + 2
            let dozer = EnemyDozerNode()
            dozer.name = "dozer"
            dozer.position = self.outsideWorld(node: dozer, angle: screenAngle)
            dozer.rotateTowards(point: .zero)
            self << dozer

            let min = -height / 2 + 5
            let max = height / 2 - 5
            for i in 0..<enemyCount {
                let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
                let location = dozer.position + CGPoint(r: 10, a: screenAngle) + CGPoint(r: r, a: screenAngle + 90.degrees)
                let enemy = EnemySoldierNode(at: location)
                enemy.name = "dozer soldier"
                enemy.rotateTo(dozer.zRotation)
                enemy.follow(leader: dozer, scatter: .None)
                self << enemy
            }
        }
    }

}
