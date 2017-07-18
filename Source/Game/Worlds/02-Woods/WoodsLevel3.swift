////
///  WoodsLevel3.swift
//

// Starts with dozers with 8 scouts behind them, and some slow soldiers
// to throw at the drone.  The second wave is a series of large scale attacks
// from slow soldiers, normal soldiers, and scouts, using the 'flying' ramming
// behavior (they move towards arbitrary midpoints before seeking the target).
// The level ends with normal soldiers attacking in wide waves.
//
// The level goes to a cut scene that introduces the upgraded dodec drone.

class WoodsLevel3: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel3Config() }

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
            director?.presentWorld(WoodsLevel3CutScene())
        }
    }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    // exp 11 * 5 = 55
    func beginWave1(nextStep: @escaping NextStepBlock) {
        moveCamera(zoom: 0.75, duration: 1)
        let angle = self.randSideAngle()
        generateWarning(angle + TAU_12, angle - TAU_12, TAU_2)
        timeline.every(4...7, start: .Delayed(), times: 5,
            block: generateDozerWithSoldiers(angle, spread: TAU_8)) ~~> nextStep()
        timeline.every(5...6, start: .Delayed(), times: 5, block: generateSlowEnemy(TAU_2, spread: TAU_16))
    }

    // exp 20 * 3 = 60
    func beginWave2(nextStep: @escaping NextStepBlock) {
        generateAllSidesWarnings()

        let t1: CGFloat = 4
        let t2 = t1 + 8
        let t3 = t2 + 6.5
        timeline.after(time: t1, block: generateArmyWave) ~~> nextStep()
        timeline.after(time: t2, block: generateArmyWave) ~~> nextStep()
        timeline.after(time: t3, block: generateArmyWave) ~~> nextStep()
    }

    // exp 10 * 4 = 40
    func beginWave3(nextStep: @escaping NextStepBlock) {
        let num = 10
        let delta = 2.5.degrees
        timeline.every(8, times: 4) {
            let angle = self.randSideAngle()
            self.generateWarning(
                angle - delta * CGFloat(num / 2),
                angle,
                angle + delta * CGFloat(num / 2)
            )
            self.timeline.at(.Delayed()) {
                for i in 0..<num {
                    let myAngle = angle + CGFloat(i - num / 2) * delta
                    self.timeline.after(time: CGFloat(i) * 0.1,
                        block: self.generateEnemy(myAngle, spread: 0, constRadius: true)) ~~> nextStep()
                }
            } ~~> nextStep()
        } ~~> nextStep()
    }

    func generateDozerWithSoldiers(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }

            let dozer = EnemyDozerNode()
            dozer.position = self.outsideWorld(node: dozer, angle: screenAngle)
            dozer.rotateTowards(self.playerNode)
            self << dozer

            let dozerRadius = dozer.position.length
            let dozerAngle = dozer.position.angle

            let enemyCount = 4
            let enemyWidth: CGFloat = 10
            let enemySpacing: CGFloat = 2
            let totalWidth: CGFloat = CGFloat(enemyCount) * (enemyWidth + enemySpacing) - enemySpacing

            let ghost = self.generateEnemyGhost(mimic: dozer, angle: screenAngle, extra: 10)
            let soldierDelta = 2 * dozer.size.width
            let soldierRadius = dozerRadius + soldierDelta
            ghost.position = CGPoint(r: soldierRadius, a: dozerAngle)
            ghost.name = "\(dozer.nodeName) ghost"
            ghost.rotateTowards(self.playerNode)

            let max = (totalWidth - enemyWidth) / 2
            let min = -max
            for i in 0..<enemyCount {
                let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
                let location1 = ghost.position + CGPoint(r: 10, a: screenAngle) + CGPoint(r: r, a: screenAngle + 90.degrees)
                let location2 = location1 + CGPoint(r: 16, a: screenAngle)
                for location in [location1, location2] {
                    let enemy = EnemyScoutNode(at: location)
                    enemy.name = "\(dozer.nodeName) \(enemy.nodeName)"
                    enemy.setRotation(ghost.zRotation)
                    enemy.follow(leader: ghost)
                    self << enemy
                }
            }
        }
    }

    private func randPoint() -> CGPoint {
        let minRadius = self.outerRadius
        let maxRadius = minRadius + 300
        return CGPoint(r: rand(min: minRadius, max: maxRadius), a: self.randSideAngle(.Right))
    }

    func generateArmyWave() {
        let numSoldiers = 9  // exp 9 * 1 = 9
        let numScouts = 5    // exp 5 * 1 = 5
        let numSlow = 3      // exp 3 * 2 = 6 => 18
        var enemies: [Node] = []
        numSoldiers.times {
            enemies << EnemySoldierNode()
        }
        numScouts.times {
            enemies << EnemyScoutNode()
        }
        numSlow.times {
            enemies << EnemySlowSoldierNode()
        }

        for enemy in enemies {
            enemy.position = self.randPoint()

            let flyingComponent = FlyingComponent()
            flyingComponent.intersectionNode = enemy.rammingComponent!.intersectionNode
            flyingComponent.bindTo(targetingComponent: enemy.playerTargetingComponent!)
            flyingComponent.maxSpeed = enemy.rammingComponent!.maxSpeed
            flyingComponent.maxTurningSpeed = enemy.rammingComponent!.maxTurningSpeed
            flyingComponent._onRammed = enemy.rammingComponent!._onRammed
            enemy.rammingComponent!.removeFromNode()
            enemy.addComponent(flyingComponent)

            self << enemy
        }
    }

}
