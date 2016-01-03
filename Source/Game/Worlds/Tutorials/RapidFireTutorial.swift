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
            self.showFirstButton()
        }
    }

    func showFirstEnemy() -> EnemySoldierNode {
        let locations = (start: CGPoint(x: 0, y: -150), end: CGPoint(x: 0, y: -50))
        let enemyNode = EnemyLeaderNode(at: locations.start)
        enemyNode.rotateTowards(self.playerNode)
        enemyNode.rammingComponent?.enabled = false
        self << enemyNode

        let moveTo = MoveToComponent()
        moveTo.target = locations.end
        moveTo.speed = EnemySoldierNode.DefaultSpeed
        enemyNode.addComponent(moveTo)
        return enemyNode
    }

    func showFirstButton() {
        let enemyNode = self.showFirstEnemy()
        timeline.after(2.25) {
            let holdButton = ButtonNode(at: CGPoint(x: 200, y: 0))
            holdButton.font = .Small
            holdButton.text = "HOLD"
            holdButton.touchableComponent!.onDragged { prevButtonLocation, buttonLocation in
                self.playerNode.rotateToComponent?.target = self.playerNode.angleTo(holdButton)
            }
            holdButton.touchableComponent!.on(.Up) { _ in
                self.playerNode.forceFire = false
                self.playerNode.firingComponent?.enabled = false
                holdButton.text = "HOLD"
                holdButton.moveToComponent?.removeFromNode()
            }
            holdButton.touchableComponent!.on(.Down) { _ in
                self.playerNode.forceFire = true
                self.playerNode.firingComponent?.enabled = true
                holdButton.text = "DRAG"

                let moveTo = MoveToComponent()
                moveTo.target = CGPoint(x: 0, y: -90)
                moveTo.speed = 80
                holdButton.addComponent(moveTo)
            }
            enemyNode.onDeath {
                self.playerNode.forceFire = false
                holdButton.removeFromParent()
                self.showSecondButton()
            }
            self << holdButton
        }
    }

    func showSecondEnemies() -> CGFloat {
        let angle = -67.75.degrees
        let enemyLocations = [
            (start: CGPoint(r: 235, a: angle), end: CGPoint(r: 35, a: angle)),
            (start: CGPoint(r: 250, a: angle), end: CGPoint(r: 50, a: angle)),
            (start: CGPoint(r: 265, a: angle), end: CGPoint(r: 65, a: angle)),
            (start: CGPoint(r: 280, a: angle), end: CGPoint(r: 80, a: angle)),
            (start: CGPoint(r: 295, a: angle), end: CGPoint(r: 95, a: angle)),
            (start: CGPoint(r: 310, a: angle), end: CGPoint(r: 110, a: angle)),
            (start: CGPoint(r: 325, a: angle), end: CGPoint(r: 125, a: angle)),
            (start: CGPoint(r: 340, a: angle), end: CGPoint(r: 140, a: angle)),
        ]
        for locations in enemyLocations {
            let enemyNode = EnemySoldierNode(at: locations.start)
            enemyNode.rotateTowards(self.playerNode)
            enemyNode.rammingComponent?.enabled = false
            self << enemyNode

            let moveTo = MoveToComponent()
            moveTo.target = locations.end
            moveTo.speed = EnemySoldierNode.DefaultSpeed
            enemyNode.addComponent(moveTo)
        }
        return angle
    }

    func showSecondButton() {
        tutorialTextNode.text = "NICE!"
        let enemyAngle = showSecondEnemies()

        timeline.after(1) {
            let holdButton = ButtonNode(at: CGPoint(x: 200, y: -90))
            holdButton.font = .Small
            holdButton.text = "HOLD"
            holdButton.touchableComponent!.on(.Moved) { buttonLocation in
                let angle = self.playerNode.angleTo(holdButton) + enemyAngle
                self.playerNode.rotateToComponent?.target = angle
            }
            holdButton.touchableComponent!.on(.Up) { _ in
                self.playerNode.forceFire = false
                self.playerNode.firingComponent?.enabled = false
                holdButton.text = "HOLD"
                holdButton.moveToComponent?.removeFromNode()
            }
            holdButton.touchableComponent!.on(.Down) { _ in
                self.playerNode.forceFire = true
                self.playerNode.firingComponent?.enabled = true
                holdButton.text = "DRAG"

                let moveTo = MoveToComponent()
                moveTo.target = CGPoint(x: 200, y: 0)
                moveTo.speed = 40
                holdButton.addComponent(moveTo)
            }
            self << holdButton

            self.onNoMoreEnemies {
                holdButton.removeFromParent()
                self.done()
            }
        }
    }

    func done() {
        playerNode.forceFire = false
        tutorialTextNode.text = "YOU GOT THIS!"

        let continueText = ButtonNode(at: CGPoint(x: 100, y: -40))
        continueText.font = .Small
        continueText.text = "NEXT >"
        continueText.onTapped {
            self.director?.presentWorld(BaseLevel2())
        }
        self << continueText
    }

}