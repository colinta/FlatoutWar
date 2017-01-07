////
///  BaseLevel3.swift
//

class BaseLevel3: BaseLevel {

    override func loadConfig() -> LevelConfig { return BaseLevel3Config() }

    override func populateLevel() {
        beginWave1()
    }

    // exp 11 * 5 = 55
    func beginWave1() {
        let nextStep = afterAllWaves(nextWave: beginWave2)

        let angle = self.randSideAngle()
        generateWarning(angle + TAU_12)
        generateWarning(angle - TAU_12)
        timeline.every(8...10, start: .Delayed(), times: 5, block: self.generateDozer(angle, spread: TAU_8)) ~~> nextStep()
    }

    // exp 20 * 3 = 60
    func beginWave2() {
        let nextStep = afterAllWaves(nextWave: beginWave3)

        10.times { (i: Int) in
            generateWarning(TAU * CGFloat(i) / 10)
        }

        moveCamera(zoom: 0.75, duration: 2)
        let t1: CGFloat = 4
        let t2 = t1 + 8
        let t3 = t2 + 6.5
        timeline.after(time: t1, block: self.generateArmyWave)
        timeline.after(time: t2, block: self.generateArmyWave)
        timeline.after(time: t3, block: self.generateArmyWave)
        timeline.after(time: t3 + 1, block: nextStep())
    }

    // exp 10 * 4 = 40
    func beginWave3() {
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
                    self.timeline.after(time: CGFloat(i) * 0.1, block: self.generateEnemy(myAngle, spread: 0, constRadius: true))
                }
            }
        }
    }

    func generateDozer(_ genScreenAngle: CGFloat, spread: CGFloat) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyCount = 4
            let height: CGFloat = CGFloat(enemyCount * 12) + 2
            let dozer = EnemyDozerNode()
            dozer.name = "dozer"
            dozer.position = self.outsideWorld(node: dozer, angle: screenAngle)
            dozer.rotateTowards(point: .zero)
            self << dozer

            let min = -height / 2 + 5
            let max = height / 2 - 5
            for i in 0..<enemyCount {
                let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
                let location1 = dozer.position + CGPoint(r: 10, a: screenAngle) + CGPoint(r: r, a: screenAngle + 90.degrees)
                let location2 = location1 + CGPoint(r: 16, a: screenAngle)
                for location in [location1, location2] {
                    let enemy = EnemyScoutNode(at: location)
                    enemy.name = "dozer scout"
                    enemy.rotateTo(dozer.zRotation)
                    enemy.follow(leader: dozer, scatter: .Dodge)
                    self << enemy
                }
            }
        }
    }

    let side: Side = rand() ? .Left : .Right
    private func randPoint() -> CGPoint {
        let minRadius = self.outerRadius
        let maxRadius = minRadius + 300
        return CGPoint(r: rand(min: minRadius, max: maxRadius), a: self.randSideAngle(side))
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
