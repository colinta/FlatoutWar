////
///  TutorialLevel8.swift
//

class TutorialLevel8: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel8Config() }

    override func showFinalButtons() {
        if config.didSeeCutScene {
            super.showFinalButtons()
        }
        else {
            showCutSceneButtons()
        }
    }

    override func goToNextWorld() {
        if config.didSeeCutScene {
            super.goToNextWorld()
        }
        else {
            config.didSeeCutScene = true
            director?.presentWorld(TutorialCutScene())
        }
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
                self.generateEnemyColumn(wave1, enemy: EnemySoldierNode())()
                self.generateEnemyColumn(wave2, enemy: EnemySoldierNode())()
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

    func generateGiant(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let enemyNode = EnemyGiantNode()
            enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

}
