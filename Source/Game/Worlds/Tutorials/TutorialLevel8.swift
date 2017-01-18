////
///  TutorialLevel8.swift
//

class TutorialLevel8: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel8Config() }

    override func goToNextWorld() {
        director?.presentWorld(WorldSelectWorld())
    }

    override func populateLevel() {
        self.introduceDrone()
        moveCamera(to: CGPoint(150, 50), duration: 2)
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        let randAngle: () -> CGFloat = { return rand(min: -self.size.angle, max: TAU_4) }

        let delays: [CGFloat] = [
            0, 12, 22
        ]
        for delay in delays {
            let wave1 = randAngle()
            let wave2 = randAngle()
            timeline.at(.After(delay)) {
                self.generateWarning(wave1, wave2)
            } ~~> nextStep()
            timeline.at(.Delayed(delay)) {
                self.generateEnemyColumn(wave1)()
                self.generateEnemyColumn(wave2)()
            } ~~> nextStep()
        }
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        self.generateWarning(0, TAU_16, -TAU_16)
        timeline.every(7...9, start: .Delayed(), times: 4,
            block: generateBigJetWithFollowers(self.randSideAngle(.Right), spread: 0)) ~~> nextStep()
        timeline.every(7...9, start: .Delayed(), times: 4,
            block: generateBigJet(rand(min: -TAU_16, max: TAU_16), spread: 0)) ~~> nextStep()
    }

    func beginWave3(nextStep: @escaping NextStepBlock) {
        timeline.at(.Delayed()) {
            self.moveCamera(to: CGPoint(200, 75), zoom: 0.75, duration: 3)
        }
        timeline.at(.Delayed(3), block: generateGiant(self.size.angle))
        timeline.at(.Delayed(6), block: generateGiant(self.size.angle - TAU_16))
        timeline.at(.Delayed(10), block: generateGiant(self.size.angle + TAU_16))

        let wave1 = randSideAngle(.Right)
        let wave2 = rand(min: -TAU_4, max: -size.angle)
        self.generateWarning(wave1, wave2)
        timeline.every(1.5...2.5, start: .Delayed(), times: 10, block: generateEnemy(wave1)) ~~> nextStep()
        timeline.every(1.5...2.5, start: .Delayed(), times: 8, block: generateEnemy(wave2)) ~~> nextStep()
    }

    func generateEnemyColumn(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: EnemySoldierNode(), angle: screenAngle, extra: 10)
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
                    let enemy = EnemySoldierNode(at: origin)
                    enemy.name = "soldier"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(leader: ghost)
                    self << enemy
                }
            }
        }
    }

    func generateGiant(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let enemyNode = EnemyGiantNode()
            enemyNode.name = "giant"
            enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

}
