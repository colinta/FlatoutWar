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
        showEnemies(enemyLocations)
    }

    func showFirstButton() {
        let tapButton = Button(at: CGPoint(x: 0, y: -50))
        tapButton.style = .Circle
        tapButton.font = .Small
        tapButton.text = "TAP"
        tapButton.touchableComponent?.on(.Tapped) { tapLocation in
            let location = self.playerNode.convertPosition(tapButton) + tapLocation
            self.playerNode.rotateToComponent?.target = location.angle
        }

        onNoMoreEnemies {
            self.playerNode.targetingComponent?.currentTarget = nil
            tapButton.removeFromParent()
            self.showSecondEnemies()
        }

        self << tapButton
        defaultNode = tapButton
    }

    func showSecondEnemies() {
        tutorialTextNode.text = "NICE!"

        let enemyLocations = [
            (start: CGPoint(r: 250, a: 0.degrees), end: CGPoint(r: 35, a: 0.degrees)),
            (start: CGPoint(r: 260, a: 10.degrees), end: CGPoint(r: 35, a: 10.degrees)),
            (start: CGPoint(r: 260, a: -10.degrees), end: CGPoint(r: 35, a: -10.degrees)),
        ]
        for locations in enemyLocations {
            let enemyNode = EnemySoldierNode(at: locations.start)
            enemyNode.rammingComponent?.enabled = false
            self << enemyNode

            let moveTo = MoveToComponent()
            moveTo.target = locations.end
            moveTo.speed = EnemySoldierNode.DefaultSoldierSpeed
            enemyNode.addComponent(moveTo)
        }

        timeline.after(1) {
            self.showSecondButton()
        }
    }

    func showSecondButton() {
        let tapButton = Button(at: CGPoint(x: 150, y: 0))
        tapButton.style = .Circle
        tapButton.font = .Small
        tapButton.text = "TAP"

        tapButton.touchableComponent?.on(.Tapped) { tapLocation in
            self.playerNode.aimAt(node: tapButton, location: tapLocation)
        }

        self.onNoMoreEnemies {
            tapButton.removeFromParent()
            self.done()
        }

        self.defaultNode = tapButton

        self << tapButton
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
