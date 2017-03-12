////
///  TutorialLevel6.swift
//

class TutorialLevel6: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel6Config() }

    override func populateLevel() {
        linkWaves(beginWave2, beginWave2, beginWave3)
    }

    // cluster of enemies (60)
    func beginWave1(nextStep: @escaping NextStepBlock) {
        timeline.every(9...13, start: .Delayed(), times: 6) {
            let angle: CGFloat = rand(TAU)
            self.generateWarning(angle)
            self.timeline.at(.Delayed(), block: self.generateEnemyCluster(angle)) ~~> nextStep()
        } ~~> nextStep()
    }

    // leader w/ circular followers (66)
    func beginWave2(nextStep: @escaping NextStepBlock) {
        timeline.every(10...13, times: 6) {
            let angle: CGFloat = rand(TAU)
            self.generateWarning(angle)
            self.timeline.at(.Delayed(), block: self.generateLeaderWithCircularFollowers(angle)) ~~> nextStep()
        } ~~> nextStep()
    }

    // enemies traveling laterally (19)
    func beginWave3(nextStep: @escaping NextStepBlock) {
        let maxRay: CGFloat = size.length
        let worldSegments = CGRect(centerSize: size + EnemyScoutNode().size).segments

        timeline.every(0.3...2, times: 16) {
            let radius: CGFloat = 135 // = min(320, 568) / 2 - 25
            let targetAngle: CGFloat = rand(TAU)
            let targetPosition = CGPoint(r: radius, a: targetAngle)
            let raycast = Segment(
                p1: targetPosition,
                p2: targetPosition + CGPoint(r: maxRay, a: targetAngle ± TAU_4)
                )
            var startPosition: CGPoint?
            for segment in worldSegments {
                if raycast.intersects(segment), let intersection = raycast.intersection(segment) {
                    startPosition = intersection
                    break
                }
            }
            if let position = startPosition {
                let angle = position.angle
                self.generateWarning(angle)
                self.timeline.at(.Delayed()) {
                    let scout = EnemyScoutNode(at: position)
                    scout.initialAimTowardsTarget = false
                    scout.rotateTo(raycast.angle + TAU_2)
                    scout.rammingComponent?.tempTarget = targetPosition
                    self << scout
                } ~~> nextStep()
            }
        } ~~> nextStep()
    }

    func generateEnemyCluster(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()
            let position = self.outsideWorld(extra: 40, angle: screenAngle)

            let dist: CGFloat = 30

            10.times {
                let origin = position + CGPoint(r: rand(min: dist/2, max: dist), a: rand(TAU))
                let enemy = EnemySoldierNode(at: origin)
                self << enemy
            }
        }
    }

}
