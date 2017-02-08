////
///  BaseLevel4.swift
//

// The first wave is three sources of enemies: pairs of fast soldiers, trios of
// normal soldiers, and quads of slow soldiers. The normal and slow soldiers come
// from the same side, and are meant to be handled by the drones, the fast
// soldiers come from the opposite side, and can be handled by the Icosagon.
//
// The second wave is a double-wall of dozers guarding a column of normal
// soldiers.

class BaseLevel4: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel4Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2)
    }

    // exp 10 * 2 + 6 * 3 + 4 * 4 = 54
    func beginWave1(nextStep: @escaping NextStepBlock) {
        let side1: CGFloat, side2: Side
        if rand() {
            side1 = TAU_2
            side2 = .Right
        }
        else {
            side1 = 0
            side2 = .Left
        }
        generateWarning(
            side1,
            side1 + TAU_2,
            side1 + TAU_2 - TAU_16,
            side1 + TAU_2 + TAU_16)
        timeline.every(2...4, start: .Delayed(), times: 10, block: generateEnemyPair(side1 ± rand(TAU_12), enemy: EnemyFastSoldierNode())) ~~> nextStep()
        timeline.every(4...6, start: .Delayed(), times: 6, block: generateEnemyTrio(self.randSideAngle(side2), enemy: EnemySoldierNode())) ~~> nextStep()
        timeline.every(6...8, start: .Delayed(), times: 4, block: generateEnemyQuad(self.randSideAngle(side2), enemy: EnemySlowSoldierNode())) ~~> nextStep()
    }

    // exp 5 * 14 = 70
    func beginWave2(nextStep: @escaping NextStepBlock) {
        timeline.every(4...8, times: 5, block: self.generateDozer(self.randSideAngle())) ~~> nextStep()
    }

    func generateDozer(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }

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

            let ghost = self.generateEnemyGhost(mimic: dozer1, angle: screenAngle, extra: 10)
            let columnDelta = 3 * dozer2.size.width
            let columnRadius = dozer2Radius + columnDelta
            ghost.position = CGPoint(r: columnRadius, a: dozer1Angle)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

            let numPairs = 5
            var r: CGFloat = 0
            let dist: CGFloat = 5
            numPairs.times {
                let angle = ghost.position.angle
                let left = CGVector(r: dist, a: angle + TAU_4) + CGVector(r: r, a: angle)
                let right = CGVector(r: dist, a: angle - TAU_4) + CGVector(r: r, a: angle)
                r += 2 * dist

                let origins = [
                    ghost.position + left,
                    ghost.position + right,
                ]
                for origin in origins {
                    let enemy = EnemySoldierNode()
                    enemy.position = origin
                    enemy.name = "soldier"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(leader: ghost)
                    self << enemy
                }
            }
        }
    }

}
