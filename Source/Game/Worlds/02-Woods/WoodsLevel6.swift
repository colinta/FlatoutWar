////
///  WoodsLevel6.swift
//

class WoodsLevel6: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel6Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp: 10 * 8 = 80
    func beginWave1(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: 140), zoom: 1, duration: 1)
        generateSideWarnings(side: .right)
        timeline.every(1.5, start: .Delayed(2), times: 16, block: generateEnemy(self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(2.5, start: .Delayed(), times: 8) {
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
            self.generateEnemyTransport(.right, payload: payload)()
        } ~~> nextStep()
    }

    // exp: (2+2)*6 + 6*8 = 72, total 152
    func beginWave2(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: 50), zoom: 0.8, duration: 1)
        generateSideWarnings(side: .right)
        timeline.every(1, times: 6, block: generateDoubleDozer(±rand(self.size.angle)))
        timeline.every(2.5, start: .Delayed(), times: 8) {
            let payload = [
                EnemySoldierNode(),
                EnemyLeaderNode(),
                EnemySlowSoldierNode(),
                EnemyFastSoldierNode(),
            ]
            self.generateEnemyTransport(.right, payload: payload)()
        } ~~> nextStep()
    }

}
