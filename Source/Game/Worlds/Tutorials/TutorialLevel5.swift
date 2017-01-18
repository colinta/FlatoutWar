////
///  TutorialLevel5.swift
//

class TutorialLevel5: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel5Config() }

    override func populateLevel() {
        moveCamera(to: CGPoint(x: 180, y: 0), duration: 2)
        timeline.after(time: 1) {
            self.linkWaves(self.beginWave1, self.beginWave2, self.beginWave3, self.beginWave4)
        }
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle(.Right)
        let wave2 = wave1 ± (TAU_16 + rand(TAU_16))

        generateWarning(wave1, wave2)
        timeline.every(0.8...1.8, start: .Delayed(), times: 5, block: generateEnemyPair(wave1)) ~~> nextStep()
        timeline.every(0.8...2.8, start: .Delayed(3), times: 4, block: generateEnemyPair(wave2)) ~~> nextStep()
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        let wave1 = randSideAngle(.Right)
        let wave2 = wave1 ± (TAU_8 + rand(TAU_16))
        generateWarning(wave1, wave2)
        timeline.every(0.8...2.5, start: .Delayed(), times: 5, block: generateEnemyTrio(wave1)) ~~> nextStep()
        timeline.every(0.8...3.5, start: .Delayed(4), times: 4, block: generateEnemyTrio(wave2)) ~~> nextStep()
    }

    func beginWave3(nextStep: @escaping NextStepBlock) {
        timeline.every(2...4, times: 5) {
            let wave = self.randSideAngle(.Right)
            self.generateWarning(wave)
            self.timeline.at(.Delayed(), block: self.generateLeaderWithLinearFollowers(wave))
        } ~~> nextStep()
    }

    func beginWave4(nextStep: @escaping NextStepBlock) {
        var trios = 7
        var quads = 6
        let angles = [
            size.angle,
            size.angle / 2,
            size.angle / 6,
            0,
            -size.angle / 2,
            -size.angle * 5 / 6,
            -size.angle,
        ]
        for angle in angles {
            generateWarning(angle)
        }
        timeline.every(1...4, start: .Delayed(), until: { return trios == 0 && quads == 0 }) {
            let pickTrio = [true, false].randWeighted { $0 ? Float(trios) : Float(quads) }
            let wave = self.randSideAngle(.Right)
            let generate: Block
            if pickTrio == true {
                trios -= 1
                generate = self.generateEnemyTrio(wave)
            }
            else {
                quads -= 1
                generate = self.generateEnemyQuad(wave)
            }

            generate()
        } ~~> nextStep()
    }

    func generateEnemyPair(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(mimic: EnemyFastSoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let angle = ghost.position.angle
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)

            let origins = [
                ghost.position + left,
                ghost.position + right,
            ]
            for origin in origins {
                let enemy = EnemyFastSoldierNode(at: origin)
                enemy.name = "pair soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyTrio(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(mimic: EnemyFastSoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let angle = ghost.position.angle
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)
            let back = CGVector(r: dist * 2, a: angle)

            let origins = [
                ghost.position + left,
                ghost.position + right,
                ghost.position + back,
            ]
            for origin in origins {
                let enemy = EnemyFastSoldierNode(at: origin)
                enemy.name = "trio soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyQuad(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let dist: CGFloat = 5.5
            let ghost = self.generateEnemyGhost(mimic: EnemyFastSoldierNode(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let angle = ghost.position.angle
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)
            let back = CGVector(r: dist * 2, a: angle)

            let origins = [
                ghost.position + left,
                ghost.position + right,
                ghost.position + left + back,
                ghost.position + right + back,
            ]
            for origin in origins {
                let enemy = EnemyFastSoldierNode(at: origin)
                enemy.name = "quad soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

}
