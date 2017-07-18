////
///  WoodsLevel7.swift
//

// Transport with soldiers, on left side only, and some soldiers from the right.
//
// Then a "classic" wave, mainly from right side, with dozers.  Soldiers from
// the left.

class WoodsLevel7: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel7Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        let angle = randSideAngle(.right)
        moveCamera(to: CGPoint(x: -50), zoom: 0.8, duration: 1)
        generateSideWarnings(side: .left)
        generateWarning(angle)
        timeline.every(1.5, start: .Delayed(2), times: 16, block: generateEnemy(angle)) ~~> nextStep()
        timeline.every(2.5...3, start: .Delayed(), times: 8) {
            let payload = [
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
            ]
            self.generateEnemyTransport(.leftEdges, payload: payload)()
        } ~~> nextStep()
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: -50), zoom: 0.8, duration: 1)
        generateBothSidesWarnings()
        timeline.every(1...3, start: .Delayed(), times: 15, block: generateJet(self.randSideAngle(.left), spread: 5.degrees)) ~~> nextStep()
        timeline.every(2...4, start: .Delayed(), times: 8, block: generateDozer(self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(2...3, start: .Delayed(), times: 15, block: generateEnemy(self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(6...8, start: .Delayed(), times: 7, block: generateLeaderEnemy(self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(4...7, start: .Delayed(), times: 7, block: generateSlowEnemy(self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(4...6, start: .Delayed(), times: 7, block: generateScouts(self.randSideAngle(.right))) ~~> nextStep()
    }

}
