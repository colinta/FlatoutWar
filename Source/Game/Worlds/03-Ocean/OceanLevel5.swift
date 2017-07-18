////
///  OceanLevel5.swift
//

class OceanLevel5: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel5Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp: 8*2 + 9 + 7*5 = 60
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
        timeline.every(2...4, start: .Delayed(2), times: 9, block: generateJet(wave1)) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(4), times: 7, block: generateBigJet(wave2)) ~~> nextStep()
    }

    // 4*6 + 16 = 40, total 100
    func beginWave2(nextStep: @escaping NextStepBlock) {
        let angles: [CGFloat] = (0..<8).map { CGFloat($0) * TAU_8 }
        timeline.every(5, start: .Delayed(), times: 6, block: generateEnemyTransport()) ~~> nextStep()
        timeline.every(2, start: .Delayed(), times: 16, block: generateEnemy(angles.rand()!)) ~~> nextStep()
    }

}
