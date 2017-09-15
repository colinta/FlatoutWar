////
///  WoodsLevel8CutScene.swift
//

class WoodsLevel8CutScene: World {
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

        // drone says
        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "THE BEACH\nIS AHEAD."
            textNode.position = CGPoint(10, 125)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self << textNode
        }

        timeline.after(time: 3.5) {
            textNode.fadeTo(0, duration: 0.5, removeNode: true)
        }
        timeline.after(time: 4, block: secondLine)
    }

    func secondLine() {
        self.moveCamera(
            to: self.upgradedDroneZoom,
            duration: 0.5
        )

        // upgradedDrone says
        let textNode1 = TextNode()
        timeline.after(time: 0.5) {
            textNode1.text = "IT'S BEING\nGUARDED BY\nOUR ALLIES!"
            textNode1.position = CGPoint(x: -10)
            textNode1.fadeTo(1, start: 0, duration: 0.5)
            self << textNode1
        }

        let textNode2 = TextNode()
        timeline.after(time: 3.5) {
            textNode1.fadeTo(0, duration: 0.5, removeNode: true)
            textNode2.text = "WE COULD\nUSE THEIR HELP."
            textNode2.position = CGPoint(50, -100)
            textNode2.fadeTo(1, start: 0, duration: 0.5)
            self << textNode2
        }

        timeline.after(time: 7) {
            textNode2.fadeTo(0, duration: 0.5, removeNode: true)
        }
        timeline.after(time: 7.5, block: thirdLine)
    }

    func thirdLine() {
        let textNode1 = TextNode()
        timeline.after(time: 0.5) {
            textNode1.text = "I WILL GO\nAHEAD TO\nEPSILON BASE,"
            textNode1.position = CGPoint(50, -100)
            textNode1.fadeTo(1, start: 0, duration: 0.5)
            self << textNode1
        }

        let textNode2 = TextNode()
        timeline.after(time: 3.5) {
            textNode1.fadeTo(0, duration: 0.5, removeNode: true)
            textNode2.text = "FIND AS MANY\nALLIES AS\nYOU CAN."
            textNode2.position = CGPoint(50, -100)
            textNode2.fadeTo(1, start: 0, duration: 0.5)
            self << textNode2
        }

        timeline.after(time: 7) {
            textNode2.fadeTo(0, duration: 0.5, removeNode: true)
        }
        timeline.after(time: 7.5, block: fourthLine)
    }

    func fourthLine() {
        self.moveCamera(
            to: self.droneZoom,
            duration: 0.5
        )

        let textNode = TextNode()
        timeline.after(time: 0.5) {
            textNode.text = "WE WILL MEET\nAT EPSILON\nBASE. HURRY!"
            textNode.position = CGPoint(10, 125)
            textNode.fadeTo(1, start: 0, duration: 0.5)
            self << textNode
        }

        timeline.after(time: 5.5) {
            textNode.fadeTo(0, duration: 1, removeNode: true)
            self.nextWorld()
        }
    }

    func nextWorld() {
        basePlayerNode.fadeTo(0, duration: 1, removeNode: true)
        droneNode.fadeTo(0, duration: 1, removeNode: true)
        upgradedDroneNode.fadeTo(0, duration: 1, removeNode: true)

        timeline.after(time: 1) {
            self.director?.presentWorld(WorldSelectWorld(beginAt: .woods))
        }
    }
}
