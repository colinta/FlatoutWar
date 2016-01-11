//
//  RapidFireTutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RapidFireTutorial: Tutorial {

    override func populateWorld() {
        super.populateWorld()

        tutorialTextNode.text = "RAPID FIRE"

        timeline.at(1) {
            self.showFirstEnemy()
        }
    }

    func showFirstEnemy() {
        let locations = (start: CGPoint(x: 0, y: -150), end: CGPoint(x: 0, y: -50))
        let enemyNode = EnemyLeaderNode(at: locations.start)
        enemyNode.rotateTowards(self.playerNode)
        enemyNode.rammingComponent?.enabled = false
        self << enemyNode

        let moveTo = MoveToComponent()
        moveTo.target = locations.end
        moveTo.speed = EnemySoldierNode.DefaultSoldierSpeed
        enemyNode.addComponent(moveTo)

        timeline.after(1.5, block: showFirstButton)
    }

    func showFirstButton() {
        let holdButton = Button(at: CGPoint(x: 200, y: 0))
        holdButton.font = .Small
        holdButton.text = "HOLD"
        holdButton.touchableComponent!.onDragged { prevLoc, loc in
            let prevWorldLoc = self.convertPoint(prevLoc, fromNode: holdButton)
            let worldLoc = self.convertPoint(loc, fromNode: holdButton)

            let prevPlayerLoc = self.convertPoint(prevWorldLoc, toNode: self.playerNode)
            let playerLoc = self.convertPoint(worldLoc, toNode: self.playerNode)
            self.playerNode.onTouchDragged(prevPlayerLoc, location: playerLoc)
        }
        holdButton.touchableComponent!.on(.Down) { _ in
            self.playerNode.overrideForceFire = true
            self.playerNode.firingComponent?.enabled = true
            holdButton.text = "DRAG"
        }
        holdButton.touchableComponent!.on(.Up) { _ in
            self.playerNode.overrideForceFire = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.text = "HOLD"
        }
        onNoMoreEnemies {
            self.playerNode.overrideForceFire = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.removeFromParent()
            self.showSecondEnemies()
        }
        self << holdButton
    }

    func showSecondEnemies() {
        tutorialTextNode.text = "NICE!"

        let angle = -67.75.degrees
        let enemyLocations = [
            (start: CGPoint(r: 235, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 250, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 265, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 280, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 295, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 310, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 325, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 340, a: angle), end: CGPoint(r: 50, a: angle)),
        ]
        for locations in enemyLocations {
            let enemyNode = EnemySoldierNode(at: locations.start)
            enemyNode.rotateTowards(self.playerNode)
            enemyNode.rammingComponent?.enabled = false
            self << enemyNode

            let moveTo = MoveToComponent()
            moveTo.target = locations.end
            moveTo.speed = EnemySoldierNode.DefaultSoldierSpeed
            enemyNode.addComponent(moveTo)
        }

        timeline.after(1, block: showSecondButton)
    }

    func showSecondButton() {
        let holdButton = Button(at: CGPoint(x: 200, y: -90))
        holdButton.font = .Small
        holdButton.text = "HOLD"
        holdButton.touchableComponent!.onDragged { prevLoc, loc in
            let prevWorldLoc = self.convertPoint(prevLoc, fromNode: holdButton)
            let worldLoc = self.convertPoint(loc, fromNode: holdButton)

            let prevPlayerLoc = self.convertPoint(prevWorldLoc, toNode: self.playerNode)
            let playerLoc = self.convertPoint(worldLoc, toNode: self.playerNode)
            self.playerNode.onTouchDragged(prevPlayerLoc, location: playerLoc)

            self.playerNode.overrideForceFire = true
            self.playerNode.firingComponent?.enabled = true
        }
        holdButton.touchableComponent!.on(.Up) { _ in
            self.playerNode.overrideForceFire = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.text = "HOLD"
        }
        holdButton.touchableComponent!.on(.Down) { _ in
            self.playerNode.overrideForceFire = true
            self.playerNode.firingComponent?.enabled = true
            holdButton.text = "DRAG"
        }
        self << holdButton

        self.onNoMoreEnemies {
            holdButton.removeFromParent()
            self.done()
        }
    }

    func done() {
        playerNode.overrideForceFire = false
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
