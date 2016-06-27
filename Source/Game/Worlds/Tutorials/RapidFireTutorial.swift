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
            self.showTurrets()
        }
    }

    func showTurrets() {
        let turret = RapidTurret()
        let button = turret.button()

        let label = TextNode()
        label.text = "↓"
        label.fixedPosition = .Bottom(x: 0, y: 60)
        label.alpha = 0
        gameUI << label
        let cancel = timeline.cancellable.after(2) {
            label.fadeTo(1, duration: 0.5)
            self.bounce(label)
        }

        button.onTapped {
            label.removeFromParent()
            cancel()
            button.fadeTo(0, duration: 0.3, removeNode: true)
            self.playerNode.turret = turret
            self.showFirstEnemy()
        }

        let start: Position = .Bottom(
            x: 0,
            y: -22
        )
        let dest: Position = .Bottom(
            x: start.x,
            y: 22
        )
        button.fixedPosition = start
        gameUI << button
        button.moveTo(dest, duration: 0.5)
    }

    func bounce(node: Node, direction: Int = 1) {
        var p = node.position
        if direction < 0 {
            p.y -= 30
        }
        else if direction > 0 {
            p.y += 30
        }

        node.moveTo(p, duration: 0.5).onArrived {
            self.bounce(node, direction: -direction)
        }
    }

    func showFirstEnemy() {
        let locations = (start: CGPoint(x: 0, y: -200), end: CGPoint(x: 0, y: -50))
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
        holdButton.text = "HOLD"
        holdButton.touchableComponent!.onDragged { prevLoc, loc in
            let prevWorldLoc = self.convertPoint(prevLoc, fromNode: holdButton)
            let worldLoc = self.convertPoint(loc, fromNode: holdButton)

            let prevPlayerLoc = self.convertPoint(prevWorldLoc, toNode: self.playerNode)
            let playerLoc = self.convertPoint(worldLoc, toNode: self.playerNode)
            self.playerNode.onDraggedAiming(prev: prevPlayerLoc, location: playerLoc)
        }
        holdButton.touchableComponent!.on(.Down) { _ in
            self.playerNode.forceFireEnabled = true
            self.playerNode.firingComponent?.enabled = true
            holdButton.text = "DRAG"
        }
        holdButton.touchableComponent!.on(.Up) { _ in
            self.playerNode.forceFireEnabled = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.text = "HOLD"
        }

        onNoMoreEnemies {
            self.playerNode.forceFireEnabled = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.removeFromParent()
            self.showSecondButton()
        }

        self << holdButton
        defaultNode = holdButton
    }

    func showSecondButton() {
        let angle = -67.75.degrees
        let minDelta = 4.degrees
        let tapButton = Button(at: CGPoint(r: 75, a: angle))
        tapButton.style = .Circle
        tapButton.text = "TAP"
        self << tapButton

        let toAim = TextNode(at: tapButton.position - CGPoint(y: 50))
        toAim.text = "TO AIM"
        self << toAim

        tapButton.touchableComponent?.on(.Tapped) { tapLocation in
            let location = self.playerNode.convertPosition(tapButton) + tapLocation
            self.playerNode.rotateToComponent?.target = location.angle

            let delta = abs(deltaAngle(location.angle, target: angle))
            if delta < minDelta {
                tapButton.removeFromParent()
                toAim.removeFromParent()
                self.showSecondEnemies()
                self.showSecondHoldButton()
            }
        }
        defaultNode = tapButton
    }

    func showSecondHoldButton() {
        let holdButton = Button(at: CGPoint(x: 200, y: -90))
        holdButton.text = "HOLD"
        holdButton.touchableComponent!.onDragged { prevLoc, loc in
            let prevWorldLoc = self.convertPoint(prevLoc, fromNode: holdButton)
            let worldLoc = self.convertPoint(loc, fromNode: holdButton)

            let prevPlayerLoc = self.convertPoint(prevWorldLoc, toNode: self.playerNode)
            let playerLoc = self.convertPoint(worldLoc, toNode: self.playerNode)
            self.playerNode.onDraggedAiming(prev: prevPlayerLoc, location: playerLoc)

            self.playerNode.forceFireEnabled = true
            self.playerNode.firingComponent?.enabled = true
        }
        holdButton.touchableComponent!.on(.Up) { _ in
            self.playerNode.forceFireEnabled = false
            self.playerNode.firingComponent?.enabled = false
            holdButton.text = "HOLD"
        }
        holdButton.touchableComponent!.on(.Down) { _ in
            self.playerNode.forceFireEnabled = true
            self.playerNode.firingComponent?.enabled = true
            holdButton.text = "DRAG"
        }
        self << holdButton
        defaultNode = holdButton

        self.onNoMoreEnemies {
            holdButton.removeFromParent()
            self.done()
        }
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
    }

    func done() {
        playerNode.forceFireEnabled = false
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
