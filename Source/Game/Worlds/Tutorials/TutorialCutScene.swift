////
///  TutorialCutScene.swift
//

class TutorialCutScene: World {
    let basePlayerNode = BasePlayerNode()
    let droneNode = DroneNode()

    let baseZoom = CGPoint(45, 25)
    let droneZoom = CGPoint(-45, -25)

    override func populateWorld() {
        let zoomed = Node()
        zoomed.setScale(1.5)

        basePlayerNode.rotateTo(TAU_2)
        basePlayerNode.radarSprite.visible = false
        basePlayerNode.position = CGPoint(90, 50)
        zoomed << basePlayerNode

        droneNode.position = CGPoint(-90, -50)
        droneNode.fixedRadar.visible = false
        droneNode.growingRadar.visible = false
        zoomed << droneNode

        self << zoomed

        timeline.after(time: 1) {
            self.moveCamera(
                to: self.baseZoom,
                duration: 0.5
            )
        }
        timeline.after(time: 1.5, block: firstLine)
    }

    func firstLine() {
        let textNode = TextNode()
        textNode.text = "HAVE YOU SEEN\nOTHER SURVIVORS?"
        textNode.position = CGPoint(-45, 75)
        textNode.fadeTo(1, start: 0, duration: 0.5)
        self << textNode

        timeline.after(time: 3) {
            self.moveCamera(
                to: self.droneZoom,
                duration: 0.5
            )
            textNode.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 3.5, block: secondLine)
    }

    func secondLine() {
        let textNode = TextNode()
        textNode.text = "THROUGH THE WOODS,\nAT EPSILON BASE!"
        textNode.position = CGPoint(45, -75)
        textNode.fadeTo(1, start: 0, duration: 0.5)
        self << textNode

        timeline.after(time: 3) {
            textNode.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 3.5, block: thirdLine)
    }

    func thirdLine() {
        let textNode = TextNode()
        textNode.text = "THEY WERE UNDER\nATTACK WHEN I\nWAS LAST THERE."
        textNode.position = CGPoint(70, -75)
        textNode.fadeTo(1, start: 0, duration: 0.5)
        self << textNode

        timeline.after(time: 4) {
            self.moveCamera(
                to: self.baseZoom,
                duration: 0.5
            )
            textNode.fadeTo(0, duration: 0.5)
        }
        timeline.after(time: 4.5, block: fourthLine)
    }

    func fourthLine() {
        let textNode = TextNode()
        textNode.text = "THEN WE MUST NOT\nWASTE ANY MORE\nTIME. TO EPSILON!"
        textNode.position = CGPoint(-45, 75)
        textNode.fadeTo(1, start: 0, duration: 0.5)
        self << textNode

        timeline.after(time: 4) {
            textNode.fadeTo(0, duration: 1)
            self.basePlayerNode.fadeTo(0, duration: 1)
            self.droneNode.fadeTo(0, duration: 1)
        }
        timeline.after(time: 5, block: nextWorld)
    }

    func nextWorld() {
        director?.presentWorld(WorldSelectWorld(beginAt: .Woods))
    }
}
