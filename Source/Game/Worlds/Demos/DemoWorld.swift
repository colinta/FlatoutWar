////
///  DemoWorld.swift
//

class DemoWorld: World {
    let playerNode = BasePlayerNode()

    override func populateWorld() {
        defaultNode = playerNode
        self << playerNode

        let closeButton = CloseButton()
        closeButton.onTapped {
            self.director?.presentWorld(TutorialSelectWorld())
        }
        ui << closeButton

        let restartButton = Button()
        restartButton.fixedPosition = .topLeft(x: 15, y: -15)
        restartButton.setScale(0.5)
        restartButton.size = CGSize(60)
        restartButton.text = "O"
        restartButton.onTapped {
            self.restartWorld()
        }
        ui << restartButton
    }

    override func worldShook() {
        super.worldShook()
        if timeRate == 0.5 { timeRate = 1 }
        else { timeRate = 0.5 }
    }

}
