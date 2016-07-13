////
///  Tutorial.swift
//

class Tutorial: World {
    typealias Locations = [(start: CGPoint, end: CGPoint)]

    let tutorialTextNode = TextNode()
    var nextWorld: World?
    let playerNode = BasePlayerNode()
    var whyNodes: [Node] = []
    let closeButton = CloseButton()

    func goToNextWorld() {
        self.director?.presentWorld(nextWorld ?? WorldSelectWorld(beginAt: .Tutorial))
    }

    func showWhy(lines: [String]) {
        for node in whyNodes {
            node.fadeTo(0, duration: 1, removeNode: true)
        }

        whyNodes = []
        var y: CGFloat = -165 + 20 * CGFloat(lines.count)
        var delay: CGFloat = 0
        for line in lines {
            let why = TextNode()
            why.textScale = 0.75
            why.text = line
            why.position = CGPoint(y: y)
            why.alpha = 0
            timeline.after(delay) {
                why.fadeTo(1, duration: 0.4)
            }
            ui << why
            delay += 0.2
            y -= 20

            whyNodes << why
        }
    }

    func addContinueButton() {
        let continueButton = Button(fixed: .Right(x: -75, y: 0))
        continueButton.setScale(1.5)
        continueButton.text = "NEXT >"
        continueButton.onTapped {
            self.goToNextWorld()
        }
        ui << continueButton
        updateFixedNode(continueButton)
    }

    override func populateWorld() {
        setScale(1.5)
        moveCamera(to: CGPoint(x: 80, y: -80), duration: 0)

        tutorialTextNode.fixedPosition = .Top(x: 0, y: -20)
        tutorialTextNode.setScale(1.5)
        ui << tutorialTextNode

        closeButton.visible = false
        closeButton.onTapped { _ in
            self.goToNextWorld()
        }
        ui << closeButton

        playerNode.touchableComponent?.enabled = false
        self << playerNode
    }

    func showEnemies(enemyLocations: Locations) -> [EnemySoldierNode] {
        var nodes: [EnemySoldierNode] = []
        for locations in enemyLocations {
            let enemyNode = EnemySoldierNode(at: locations.start)
            enemyNode.rotateTowards(self.playerNode)
            enemyNode.rammingComponent?.enabled = false
            self << enemyNode

            let moveTo = MoveToComponent()
            moveTo.target = locations.end
            moveTo.speed = EnemySoldierNode.DefaultSoldierSpeed
            enemyNode.addComponent(moveTo)
            nodes << enemyNode
        }
        return nodes
    }

}
