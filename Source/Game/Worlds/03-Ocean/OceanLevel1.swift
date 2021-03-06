////
///  OceanLevel1.swift
//

class OceanLevel1: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel1Config() }

    override func populateWorld() {
        super.populateWorld()

        for player in players {
            guard let node = player as? GuardNode else { continue }

            node.draggableComponent?.maintainDistance(150, around: playerNode)
        }
    }

    override func populateZoomOut() {
        guard config.defaults("didSeeIntro").bool != true else {
            super.populateZoomOut()
            return
        }
        config.defaults("didSeeIntro", set: true)

        let guardTextNode = TextNode()
        timeline.after(time: 0.5) {
            guardTextNode.text = "SEPTENTRION\nGUARDS\n\nWORK BEST\nIN GROUPS."
            guardTextNode.position = CGPoint(50, 0)
            guardTextNode.fadeTo(1, start: 0, duration: 0.5)
            self.gameUI << guardTextNode
        }

        timeline.after(time: 3.5) {
            guardTextNode.fadeTo(0, duration: 0.5, removeNode: true)
        }
        timeline.after(time: 4) {
            let fadeDuration: CGFloat = 0.5
            let moveDuration: CGFloat = 2

            let powerupTextNode = TextNode(at: CGPoint(-180, 170))
            powerupTextNode.text = "NEW POWERUPS!"
            powerupTextNode.fadeTo(1, start: 0, duration: fadeDuration)
            self.gameUI << powerupTextNode

            let arrowTextNode = TextNode(at: CGPoint(-270, 140))
            arrowTextNode.text = "←"
            arrowTextNode.fadeTo(1, start: 0, duration: fadeDuration)
            arrowTextNode.moveTo(arrowTextNode.position + CGPoint(y: -90), duration: moveDuration)
            self.timeline.after(time: moveDuration - fadeDuration) {
                powerupTextNode.fadeTo(0, duration: fadeDuration, removeNode: true)
                arrowTextNode.fadeTo(0, duration: fadeDuration, removeNode: true)
            }
            self.gameUI << arrowTextNode

            super.populateZoomOut()
        }
    }

    override func populateLevel() {
        linkWaves(
            beginWave1,
            beginWave2
            )
    }

    // BOATS
    func beginWave1(nextStep: @escaping NextStepBlock) {
        timeline.every(1.5...2.5, start: .Delayed(), times: 20,
           block: self.generateBoat(payload: .twoSoldiers, destX: oceanStartX, self.randSideAngle(.right))) ~~> nextStep()
    }

    // BOATS onslaught
    func beginWave2(nextStep: @escaping NextStepBlock) {
        timeline.every(1.5...2.5, start: .Delayed(), times: 20,
           block: self.generateBoat(payload: .twoSoldiers, destX: oceanStartX, self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(3...5, start: .Delayed(), times: 8,
           block: self.generateBoat(payload: .leader, destX: oceanStartX, self.randSideAngle(.right))) ~~> nextStep()
        timeline.every(2.5...4, start: .Delayed(), times: 12,
           block: self.generateBoat(payload: .scouts, destX: oceanStartX, self.randSideAngle(.right))) ~~> nextStep()
    }
}
