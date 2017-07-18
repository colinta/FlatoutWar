////
///  OceanLevel3CutScene.swift
//

class OceanLevel3CutScene: World {
    let basePlayerNode = BasePlayerNode()
    let droneNode = DroneNode()
    let upgradedDroneNode = DroneNode()

    let baseZoom = CGPoint(-45, -50)
    let droneZoom = CGPoint(-45, 50)
    let upgradedDroneZoom = CGPoint(x: 45)

    override func populateWorld() {
        upgradedDroneNode.radarUpgrade = true
        upgradedDroneNode.bulletUpgrade = true
        upgradedDroneNode.movementUpgrade = true

        let zoomed = Node()
        zoomed.setScale(1.5)

        basePlayerNode.setRotation(TAU_2)
        basePlayerNode.radarSprite.visible = false
        basePlayerNode.position = CGPoint(-90, -75)
        zoomed << basePlayerNode

        droneNode.position = CGPoint(-90, 75)
        droneNode.fixedRadar.visible = false
        droneNode.growingRadar.visible = false
        zoomed << droneNode

        upgradedDroneNode.position = CGPoint(x: size.width / 2 + upgradedDroneNode.size.width)
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
        upgradedDroneNode.moveTo(CGPoint(x: 110), speed: 60)
        basePlayerNode.rotateTo(0)

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "I SEE ANOTHER DODEC!"
            textNode.position = CGPoint(-45, 75)
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
            textNode1.text = "I AM FROM\nEPSILON BASE."
            textNode1.position = CGPoint(x: 30)
            textNode1.fadeTo(1, start: 0, duration: 0.5)
            self << textNode1
        }

        let textNode2 = TextNode()
        timeline.after(time: 3) {
            textNode1.fadeTo(0, duration: 0.5)
            textNode2.text = "WE ARE BEING\nOVERRUN BY QUADS."
            textNode2.position = CGPoint(x: 30)
            textNode2.fadeTo(1, start: 0, duration: 0.5)
            self << textNode2
        }

        timeline.after(time: 6) {
            textNode2.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 6.5, block: thirdLine)
    }

    func thirdLine() {
        self.moveCamera(
            to: self.baseZoom,
            duration: 0.5
        )

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "WE ARE ON OUR\nWAY THERE NOW."
            textNode.position = CGPoint(-50, -50)
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
            to: self.upgradedDroneZoom,
            duration: 0.5
        )

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "I WILL\nSHOW YOU THE\nWAY. WE MUST\nHURRY!"
            textNode.position = CGPoint(x: 45)
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
            self.director?.presentWorld(WorldSelectWorld(beginAt: .Ocean))
        }
    }
}
