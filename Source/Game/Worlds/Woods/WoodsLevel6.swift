////
///  WoodsLevel6.swift
//

class WoodsLevel6: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel6Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp: 80
    func beginWave1(nextStep: @escaping NextStepBlock) {
        generateSideWarnings(side: .Right)
        moveCamera(to: CGPoint(x: 140), zoom: 1, duration: 1)
        timeline.every(1, start: .Delayed(2), times: 16, block: generateEnemy(self.randSideAngle(.Right))) ~~> nextStep()
        timeline.every(2, start: .Delayed(), times: 8) {
            let payload = [
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
                EnemyScoutNode(),
            ]
            self.generateEnemyTransport(.Right, payload: payload)()
        } ~~> nextStep()
    }

    // exp: (2+2)*6 + 6*8 = 72, total 152
    func beginWave2(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: 50), zoom: 0.8, duration: 1)
        generateSideWarnings(side: .Right)
        timeline.every(1, times: 6, block: generateDoubleDozer(±rand(TAU_16)))
        timeline.every(2, start: .Delayed(), times: 8) {
            let payload = [
                EnemySoldierNode(),
                EnemyLeaderNode(),
                EnemySlowSoldierNode(),
                EnemyFastSoldierNode(),
            ]
            self.generateEnemyTransport(.Right, payload: payload)()
        } ~~> nextStep()
    }

}
