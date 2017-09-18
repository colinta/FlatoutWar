////
///  OceanLevel1.swift
//

//

class OceanLevel1: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel1Config() }

    override func populateWorld() {
        super.populateWorld()

        for player in players {
            guard let node = player as? GuardNode else { continue }

            node.preferredAngle = 0
            node.draggableComponent?.maintainDistance(150, around: playerNode)
        }
    }

    override func populateZoomOut() {
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
        // linkWaves(
        //     beginWave1,
        //     beginWave2,
        //     )
    }

    //
    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

    //
    func beginWave2(nextStep: @escaping NextStepBlock) {
    }
}
