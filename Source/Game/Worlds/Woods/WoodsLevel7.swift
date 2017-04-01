////
///  WoodsLevel7.swift
//

class WoodsLevel7: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel7Config() }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: -50), zoom: 0.8, duration: 1)
        generateSideWarnings(side: .Left)
        timeline.every(1.5, start: .Delayed(2), times: 16, block: generateEnemy(self.randSideAngle(.Right))) ~~> nextStep()
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
            self.generateEnemyTransport(.LeftEdges, payload: payload)()
        } ~~> nextStep()
    }

}
