////
///  OceanLevel1.swift
//

//

class OceanLevel1: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel1Config() }

    override func populateWorld() {
        super.populateWorld()

        for player in players {
            guard let node = player as? ShotgunNode else { continue }

            node.preferredAngle = 0
            node.draggableComponent?.maintainDistance(150, around: playerNode)
        }
    }

    override func populateZoomOut() {
        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "SEPTENTRION\nGUARDS\n\nWORK BEST\nIN GROUPS."
            textNode.position = CGPoint(50, 0)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self.gameUI << textNode
        }

        timeline.after(time: 3.5) {
            textNode.fadeTo(0, duration: 0.5, removeNode: true)
        }
        timeline.after(time: 4) {
            super.populateZoomOut()
        }
    }

    override func populateLevel() {
        let powerupTextNode = TextNode(at: CGPoint(-160, 170))
        powerupTextNode.text = "←"
        let fadeDuration: CGFloat = 0.5
        let moveDuration: CGFloat = 2
        powerupTextNode.fadeTo(1, start: 0, duration: fadeDuration)
        powerupTextNode.moveTo(powerupTextNode.position + CGPoint(y: -120), duration: moveDuration)
        timeline.after(time: moveDuration - fadeDuration) {
            powerupTextNode.fadeTo(0, duration: fadeDuration, removeNode: true)
        }
        self << powerupTextNode

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
