////
///  BaseLevel2.swift
//

// This level starts with leaders and scouts in a formation where the scouts
// protect the leader.  waves 2 & 3 are "all out" waves. wave 2 is scouts,
// normal, and slow soldiers, and wave 3 swaps slow soldiers for leaders.

class BaseLevel2: BaseLevel {

    override func loadConfig() -> LevelConfig { return BaseLevel2Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    // 84 exp
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let da: CGFloat = 5.degrees
        timeline.every(4.5...7, times: 8) {
            let angle = self.randSideAngle()
            self.generateWarning(angle)
            self.timeline.at(.Delayed()) {
                self.generateLeaderEnemy(angle, spread: 0, constRadius: true)()
                3.times { (i: Int) in
                    self.generateScouts(angle + da * CGFloat(i - 1), spread: 0, constRadius: true)()
                }
            } ~~> nextStep()
        } ~~> nextStep()
    }

    // 66 exp (150 total)
    func beginWave2(nextStep: @escaping NextStepBlock) {
        generateAllSidesWarnings()

        timeline.every(4.5, start: .Delayed(), times: 11,
            block: generateScouts(rand(TAU))) ~~> nextStep()
        timeline.every(3.5, start: .Delayed(1), times: 14,
            block: generateEnemy(rand(TAU))) ~~> nextStep()
        timeline.every(7, start: .Delayed(3), times: 7,
            block: generateSlowEnemy(rand(TAU))) ~~> nextStep()
    }

    // 80 exp (230 total)
    func beginWave3(nextStep: @escaping NextStepBlock) {
        generateBothSidesWarnings()

        // 50s / times = every
        timeline.every(3.85, start: .Delayed(), times: 13,
            block: generateScouts(self.randSideAngle())) ~~> nextStep()
        timeline.every(3.5, start: .Delayed(1), times: 14,
            block: generateEnemy(self.randSideAngle())) ~~> nextStep()
        timeline.every(5.5, start: .Delayed(3), times: 9,
            block: generateLeaderEnemy(self.randSideAngle())) ~~> nextStep()
    }

}
