////
///  OceanLevel8CutScene.swift
//

class OceanLevel8CutScene: World {
    let basePlayerNode = BasePlayerNode()
    let droneNode = DroneNode()
    let upgradedDroneNode = DroneNode()

    let droneZoom = CGPoint(-45, 50)
    let upgradedDroneZoom = CGPoint(x: -45)

    override func populateWorld() {
        upgradedDroneNode.radarUpgrade = true
        upgradedDroneNode.bulletUpgrade = true
        upgradedDroneNode.movementUpgrade = true

        let zoomed = Node()
        zoomed.setScale(1.5)

        basePlayerNode.setRotation(0)
        basePlayerNode.radarSprite.visible = false
        basePlayerNode.position = CGPoint(-90, -75)
        zoomed << basePlayerNode

        droneNode.position = CGPoint(-90, 75)
        droneNode.fixedRadar.visible = false
        droneNode.growingRadar.visible = false
        zoomed << droneNode

        upgradedDroneNode.position = CGPoint(x: -110)
        upgradedDroneNode.fixedRadar.visible = false
        upgradedDroneNode.growingRadar.visible = false
        zoomed << upgradedDroneNode

        self << zoomed

        timeline.after(time: 1, block: firstLine)
    }

    func firstLine() {
        self.moveCamera(
            to: self.droneZoom,
            duration: 0.5
        )

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "EPSILON IS\nUNDER ATTACK!"
            textNode.position = CGPoint(10, 125)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self << textNode
        }

        timeline.after(time: 3) {
            textNode.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 3.5, block: secondLine)
    }

    func secondLine() {
        self.moveCamera(
            to: self.upgradedDroneZoom,
            duration: 0.5
        )

        let textNode1 = TextNode()
        timeline.after(time: 0.5) {
            textNode1.text = "THE QUADS ARE\nATTACKING FROM\nALL SIDES."
            textNode1.position = CGPoint(x: -10)
            textNode1.fadeTo(1, start: 0, duration: 0.5)
            self << textNode1
        }

        let textNode2 = TextNode()
        timeline.after(time: 3) {
            textNode1.fadeTo(0, duration: 0.5)
            textNode2.text = "WE MUST NOT\nWASTE TIME.\nTO BATTLE!"
            textNode2.position = CGPoint(0, -100)
            textNode2.fadeTo(1, start: 0, duration: 0.5)
            self << textNode2
        }

        timeline.after(time: 6) {
            textNode2.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 6.5, block: thirdLine)
    }

    func thirdLine() {
        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "I WILL PROTECT\nTHE NORTH\nGATE."
            textNode.position = CGPoint(0, -100)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self << textNode
        }

        timeline.after(time: 4) {
            textNode.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 4.5, block: fourthLine)
    }

    func fourthLine() {
        self.moveCamera(
            to: self.droneZoom,
            duration: 0.5
        )

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "WE WILL JOIN\nTHE DEFENSES\nAT THE EAST WALL."
            textNode.position = CGPoint(10, 125)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self << textNode
        }

        timeline.after(time: 4) {
            textNode.fadeTo(0, duration: 1)
            self.nextWorld()
        }
    }

    func nextWorld() {
        basePlayerNode.fadeTo(0, duration: 1)
        droneNode.fadeTo(0, duration: 1)
        upgradedDroneNode.fadeTo(0, duration: 1)

        timeline.after(time: 1) {
            self.director?.presentWorld(WorldSelectWorld(beginAt: .ocean))
        }
    }
}
