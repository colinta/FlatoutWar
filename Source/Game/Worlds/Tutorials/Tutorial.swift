//
//  Tutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Tutorial: World {
    typealias Locations = [(start: CGPoint, end: CGPoint)]

    let tutorialTextNode = TextNode()
    var nextWorld: World?
    let playerNode = BasePlayerNode()

    required init() {
        super.init()
        pauseable = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func goToNextWorld() {
        self.director?.presentWorld(nextWorld ?? WorldSelectWorld(beginAt: .Tutorial))
    }

    func showWhy(lines: [String]) {
        var y: CGFloat = -125
        var delay: CGFloat = 0
        for line in lines {
            let why = TextNode()
            why.textScale = 0.5
            why.text = line
            why.position = CGPoint(x: 50, y: y)
            why.alpha = 0
            timeline.after(delay) {
                why.fadeTo(1, duration: 0.4)
            }
            self << why
            delay += 0.2
            y -= 20
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

        let closeButton = CloseButton()
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
