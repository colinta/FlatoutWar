////
///  TutorialLevel7.swift
//

class TutorialLevel7: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel7Config() }

    override func populateLevel() {
        self.introduceDrone()

        timeline.after(time: 1) {
            self.linkWaves(self.beginWave1, self.beginWave2, self.beginWave3)
        }
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1: CGFloat = TAU / 32
        let wave2: CGFloat = -TAU / 32
        let wave3 = TAU_2 ± rand(TAU_16)
        generateWarning(wave1, wave2, wave3)
        generateWarning(wave3 - TAU_8, wave3 + TAU_8, wave3 - TAU_16, wave3 + TAU_16)

        timeline.every(2.5...4.5, start: .Delayed(), times: 8, block: generateEnemy(wave1)) ~~> nextStep()
        timeline.every(2.5...4.5, start: .Delayed(), times: 8, block: generateEnemy(wave2)) ~~> nextStep()

        timeline.every(4...7, start: .Delayed(), times: 5, block: generateLeaderEnemy(wave3, spread: TAU_16)) ~~> nextStep()
        timeline.every(1.5...2.5, start: .Delayed(), times: 14, block: generateEnemy(wave3, spread: TAU_8)) ~~> nextStep()
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(x: -120, y: 0), duration: 3)
        }

        let wave1 = TAU_2 + TAU_16
        let wave2 = TAU_2 - TAU_16
        timeline.at(.Delayed(1)) {
            self.generateWarning(wave1, wave1 - TAU_16, wave1 + TAU_16)
        }
        timeline.at(.Delayed(7)) {
            self.generateWarning(wave2, wave2 - TAU_16, wave2 + TAU_16)
        }
        timeline.every(0.5, start: .Delayed(4), times: 20,
            block: generateEnemy(wave1, spread: TAU_16)) ~~> nextStep()
        timeline.every(0.5, start: .Delayed(10), times: 20,
            block: generateEnemy(wave2, spread: TAU_16)) ~~> nextStep()
    }

    func beginWave3(nextStep: @escaping NextStepBlock) {
        let wave1 = TAU_2
        let wave2 = ±TAU_4
        let wave3 = TAU_2
        generateWarning(wave1)

        timeline.every(0.5, start: .Delayed(), times: 20, block: generateJet(wave1, spread: 20)) ~~> nextStep()
        timeline.at(.Delayed(9)) {
            self.generateWarning(wave2, wave3)
        }
        timeline.every(0.5, start: .Delayed(12), times: 20, block: generateJet(wave2, spread: 20)) ~~> nextStep()
        timeline.every(0.4, start: .Delayed(12), times: 20, block: generateJet(wave3, spread: 20)) ~~> nextStep()
    }

}
