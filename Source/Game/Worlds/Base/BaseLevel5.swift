////
///  BaseLevel5.swift
//

class BaseLevel5: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel5Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp: 8*2 + 10 + 6*5 = 56
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2: CGFloat = rand(TAU)
        generateWarning(wave1, wave2)

        let count = 8
        var angles: [CGFloat] = (0..<count).map { CGFloat($0) * TAU / CGFloat(count) ± rand(1.degrees) }
        timeline.every(0.2, start: .Delayed(), times: count) {
            let angle: CGFloat = angles.randomPop() ?? rand(TAU)
            self.generateDozer(angle)()
        } ~~> nextStep()
        timeline.every(1...3, start: .Delayed(2), times: 10, block: generateJet(wave1)) ~~> nextStep()
        timeline.every(2...4, start: .Delayed(4), times: 6, block: generateBigJet(wave2)) ~~> nextStep()
    }

    // 84, total 140
    func beginWave2(nextStep: @escaping NextStepBlock) {
        let angles: [CGFloat] = (0..<8).map { CGFloat($0) * TAU_8 }
        timeline.every(5, start: .Delayed(), times: 6, block: generateEnemyTransport(self.randSideAngle())) ~~> nextStep()
        timeline.every(2, start: .Delayed(), times: 15, block: generateEnemy(angles.rand()!)) ~~> nextStep()
    }

}
