//
//  AutoFireTutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class AutoFireTutorial: Tutorial {

    override func populateWorld() {
        super.populateWorld()

        playerNode.touchableComponent?.enabled = false

        tutorialTextNode.text = "AUTO AIM"

        timeline.at(1) {
            self.showFirstEnemies()
        }
        timeline.at(3.25) {
            self.showFirstButton()
        }
    }

    func showFirstEnemies() {
        let enemyLocations = [
            (start: CGPoint(r: 150, a: -90.degrees), end: CGPoint(r: 100, a: -90.degrees)),
            (start: CGPoint(r: 160, a: -100.degrees), end: CGPoint(r: 110, a: -100.degrees)),
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
    }

    func showFirstButton() {
        let tapButton = ButtonNode(at: CGPoint(x: 0, y: -50))
        tapButton.style = .Circle
        tapButton.font = .Small
        tapButton.text = "TAP"
        tapButton.onTapped {
            self.playerNode.rotateToComponent?.target = self.playerNode.angleTo(tapButton)
            tapButton.removeFromParent()

            self.timeline.after(4.5) {
                self.showSecondButton()
            }
        }
        self << tapButton
    }

    func showSecondEnemies() {
        let enemyLocations = [
            (start: CGPoint(r: 250, a: 0.degrees), end: CGPoint(r: 35, a: 0.degrees)),
            (start: CGPoint(r: 260, a: 10.degrees), end: CGPoint(r: 35, a: 10.degrees)),
            (start: CGPoint(r: 260, a: -10.degrees), end: CGPoint(r: 35, a: -10.degrees)),
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
    }

    func showSecondButton() {
        tutorialTextNode.text = "NICE!"
        showSecondEnemies()

        timeline.after(1) {
            let tapButton = ButtonNode(at: CGPoint(x: 150, y: 0))
            tapButton.style = .Circle
            tapButton.font = .Small
            tapButton.text = "TAP"
            tapButton.onTapped {
                self.playerNode.targetingComponent?.currentTarget = nil
                self.playerNode.rotateToComponent?.target = self.playerNode.angleTo(tapButton)
                tapButton.removeFromParent()

                self.timeline.after(5.5) {
                    self.done()
                }
            }
            self << tapButton
        }
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        let continueText = ButtonNode(at: CGPoint(x: 100, y: -40))
        continueText.font = .Small
        continueText.text = "NEXT >"
        continueText.onTapped {
            self.director?.presentWorld(BaseLevel1())
        }
        self << continueText
    }
}
