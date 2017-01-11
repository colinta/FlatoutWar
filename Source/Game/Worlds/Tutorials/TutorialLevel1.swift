////
///  TutorialLevel1.swift
//

class TutorialLevel1: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel1Config() }

    override func populateWorld() {
        super.populateWorld()
        (playerNode as! BasePlayerNode).forceFireEnabled = false
    }

    override func populateLevel() {
        (playerNode as! BasePlayerNode).forceFireEnabled = false
        linkWaves(beginWave1, beginWave2, beginWave3, beginWave4)
    }

    // two sources of weak enemies
    func beginWave1(nextStep: NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_2 ± rand(min: TAU_8, max: TAU_4)
        generateWarning(wave1, wave2)
        timeline.every(1.5...2.5, start: .Delayed(), times: 20, block: self.generateEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...4, start: .Delayed(), times: 13, block: self.generateEnemy(wave2)) ~~> nextStep()
    }

    // four sources of weak enemies
    func beginWave2(nextStep: NextStepBlock) {
        let wave1: CGFloat = rand(TAU)
        let wave2 = wave1 + TAU_4 - rand(TAU_8)
        let wave3 = wave1 - TAU_4 + rand(TAU_8)
        let wave4 = wave1 ± rand(TAU_8)
        generateWarning(wave1, wave2, wave3, wave4)
        timeline.every(3...4, start: .Delayed(), times: 6, block: self.generateEnemy(wave1)) ~~> nextStep()
        timeline.every(2...3, start: .Delayed(5), times: 6, block: self.generateEnemy(wave2)) ~~> nextStep()
        timeline.every(2, start: .Delayed(10), times: 6, block: self.generateEnemy(wave3)) ~~> nextStep()
        timeline.every(1, start: .Delayed(21), times: 8, block: self.generateEnemy(wave4)) ~~> nextStep()
    }

    // random
    func beginWave3(nextStep: NextStepBlock) {
        generateAllSidesWarnings()

        timeline.every(1...2.5, start: .Delayed(), times: 10) {
            self.generateEnemy(rand(TAU), constRadius: true)()
        } ~~> nextStep()
    }

    // one source of weak, one source of strong
    func beginWave4(nextStep: NextStepBlock) {
        let wave_leader = size.angle
        let wave_soldier: CGFloat = -size.angle ± rand(TAU_16)
        generateWarning(wave_leader, wave_soldier)
        timeline.every(4...6, start: .Delayed(), times: 5, block: self.generateLeaderEnemy(wave_leader)) ~~> nextStep()
        timeline.every(1.5...3.0, start: .Delayed(1), times: 16, block: self.generateEnemy(wave_soldier)) ~~> nextStep()
    }

}
