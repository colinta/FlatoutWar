//
//  Tutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Tutorial: World {
    let tutorialTextNode = TextNode()
    let playerNode = BasePlayerNode()
    typealias Locations = [(start: CGPoint, end: CGPoint)]

    required init() {
        super.init()
        pauseable = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func moveCamera(to target: CGPoint, handler: MoveToComponent.OnArrived? = nil) {
        let moveTo = MoveToComponent()
        moveTo.target = target
        moveTo.speed = 80
        if let handler = handler {
            moveTo.onArrived(handler)
        }
        moveTo.removeComponentOnArrived()
        cameraNode?.addComponent(moveTo)
    }

    func goToNextWorld() {
        self.director?.presentWorld(nextWorld())
    }

    func nextWorld() -> World {
        return LevelSelectWorld()
    }

    func addContinueButton() {
        let continueButton = Button(fixed: .Right(x: -75, y: 0))
        continueButton.setScale(1.5)
        continueButton.font = .Small
        continueButton.text = "NEXT >"
        continueButton.onTapped {
            self.goToNextWorld()
        }
        ui << continueButton
        updateFixedNode(continueButton)
    }

    override func populateWorld() {
        setScale(1.5)
        cameraNode = Node(at: CGPoint(x: 80, y: -80))

        tutorialTextNode.fixedPosition = .Top(x: 0, y: -20)
        tutorialTextNode.font = .Small
        tutorialTextNode.setScale(1.5)
        ui << tutorialTextNode

        let closeButton = Button(fixed: .TopRight(x: -15, y: -15))
        closeButton.setScale(0.5)
        closeButton.text = "×"
        closeButton.size = CGSize(60)
        closeButton.onTapped { _ in
            self.goToNextWorld()
        }
        ui << closeButton

        playerNode.touchableComponent?.enabled = false
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
            moveTo.speed = EnemySoldierNode.DefaultSpeed
            enemyNode.addComponent(moveTo)
            nodes << enemyNode
        }
        return nodes
    }

}
