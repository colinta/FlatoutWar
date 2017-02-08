////
///  BaseLevel4.swift
//

// The first wave is three sources of enemies: pairs of fast soldiers, trios of
// normal soldiers, and quads of slow soldiers. The normal and slow soldiers come
// from the same side, and are meant to be handled by the drones, the fast
// soldiers come from the opposite side, and can be handled by the Icosagon.
//
// The second wave is a double-wall of dozers guarding columns of normal
// soldiers.

class BaseLevel4: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel4Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp 10 * 2 + 6 * 3 + 4 * 4 = 54
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let side1: CGFloat = 0
        let side2 = Side.Left
        generateWarning(
            side1,
            side1 + TAU_2,
            side1 + TAU_2 - TAU_16,
            side1 + TAU_2 + TAU_16)
        timeline.every(2...4, start: .Delayed(), times: 10, block: generateEnemyPair(side1 ± rand(TAU_12), enemy: EnemyFastSoldierNode())) ~~> nextStep()
        timeline.every(4...6, start: .Delayed(), times: 6, block: generateEnemyTrio(self.randSideAngle(side2), enemy: EnemySoldierNode())) ~~> nextStep()
        timeline.every(6...8, start: .Delayed(), times: 4, block: generateEnemyQuad(self.randSideAngle(side2), enemy: EnemySlowSoldierNode())) ~~> nextStep()
    }

    // exp 9 * 4 + 6 * 10 = 96
    func beginWave2(nextStep: @escaping NextStepBlock) {
        moveCamera(zoom: 0.8, duration: 1)

        let count = 9
        var angles: [CGFloat] = (0..<count).map { CGFloat($0) * TAU / CGFloat(count) }
        timeline.every(0.1...0.3, start: .Delayed(), times: count) {
            let angle: CGFloat = angles.randomPop() ?? rand(TAU)
            self.generateDozer(angle)()
        } ~~> nextStep()
        timeline.every(6...8, start: .Delayed(1), times: 6, block: generateEnemyColumn(rand(TAU), enemy: EnemySoldierNode()))
    }

    func generateDozer(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()

            let dozer1 = EnemyDozerNode()
            dozer1.name = "dozer1"
            dozer1.position = self.outsideWorld(node: dozer1, angle: screenAngle)
            dozer1.rotateTowards(self.playerNode)
            self << dozer1

            let dozer1Radius = dozer1.position.length
            let dozer1Angle = dozer1.position.angle

            let dozer2 = EnemyDozerNode()
            dozer2.name = "dozer2"
            let dozer2Delta = 2 * dozer2.size.width
            let dozer2Radius = dozer1Radius + dozer2Delta
            dozer2.position = CGPoint(r: dozer2Radius, a: dozer1Angle)
            dozer2.minTargetDist = dozer1.minTargetDist + dozer2Delta
            dozer2.rotateTowards(self.playerNode)
            self << dozer2
        }
    }

}
