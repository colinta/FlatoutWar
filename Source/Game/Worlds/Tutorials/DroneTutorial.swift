//
//  DroneTutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneTutorial: Tutorial {
    let drone = DroneNode()

    override func populateWorld() {
        super.populateWorld()

        playerNode.rotateTo(TAU_2)
        tutorialTextNode.text = "DRONE"

        timeline.at(1, block: showDrone)
    }

    func showDrone() {
        drone.position = playerNode.position
        drone.alpha = 0
        drone.touchableEnabled = false
        drone.wanderingEnabled = false
        self << drone

        let fadeIn = FadeToComponent()
        fadeIn.target = 1
        fadeIn.duration = 1.4
        fadeIn.removeComponentOnFade()
        drone.addComponent(fadeIn)

        let moveTo = MoveToComponent()
        moveTo.target = CGPoint(-30, -60)
        moveTo.speed = DroneNode.DefaultSpeed
        moveTo.onArrived(showTapButton)
        moveTo.removeComponentOnArrived()
        drone.addComponent(moveTo)
    }

    func showTapButton() {
        let tapButton = Button(at: drone.position + CGPoint(y: -10))
        tapButton.style = .Circle
        tapButton.font = .Small
        tapButton.text = "TAP"
        tapButton.textSprite.position = CGPoint(y: -10)
        tapButton.onTapped {
            tapButton.removeFromParent()
            self.showFirstDemo()
        }
        self << tapButton
    }

    func showFirstDemo() {
        self.selectNode(self.drone)
        let enemies = showEnemies([(start: CGPoint(r: 250, a: 0.degrees), end: CGPoint(r: 60, a: 0.degrees))])
        let enemyNode = enemies.first!

        let holdStart = drone.position + CGPoint(x: 80, y: -10)
        let holdEnd = holdStart + CGPoint(x: 60)
        let holdButton = Button(at: holdStart)
        holdButton.style = .CircleSized(70)
        holdButton.font = .Small
        holdButton.text = "HOLD"
        self << holdButton

        holdButton.touchableComponent!.onDragged { (prev_, location_) in
            var prev = self.convertPoint(prev_, fromNode: holdButton)
            var location = self.convertPoint(location_, fromNode: holdButton)
            prev.y = 0
            location.y = 0
            self.drone.draggableComponent?.draggingMoved(prev, location: location)

            if self.drone.placeholder.position.x > 60 {
                self.drone.draggableComponent!.draggingEnded(location)
                holdButton.removeFromParent()
            }
        }
        holdButton.touchableComponent!.on(.Down) { location_ in
            var location = self.convertPoint(location_, fromNode: holdButton)
            location.y = 0
            self.drone.draggableComponent?.draggingBegan(location)
            holdButton.text = "DRAG"

            let moveTo = MoveToComponent()
            moveTo.target = holdEnd
            moveTo.speed = 80
            moveTo.onArrived() {
                if let isDragMoving = holdButton.draggableComponent?.isDragMoving
                where !isDragMoving {
                    holdButton.removeFromParent()
                }
            }
            holdButton.addComponent(moveTo)
        }
        holdButton.touchableComponent!.on(.Up) { location_ in
            var location = self.convertPoint(location_, fromNode: holdButton)
            location.y = 0
            self.drone.draggableComponent?.draggingEnded(location)
            holdButton.text = "HOLD"
            holdButton.moveToComponent?.removeFromNode()
        }

        enemyNode.onDeath {
            holdButton.removeFromParent()
            self.showSecondDemo()
        }
    }

    func showSecondDemo() {
        tutorialTextNode.text = "NICE!"

        let moveTo = MoveToComponent()
        moveTo.target = CGPoint(x: 30, y: -60)
        moveTo.speed = DroneNode.DefaultSpeed
        moveTo.removeComponentOnArrived()
        drone.addComponent(moveTo)
        playerNode.startRotatingTo(0)

        let enemies = [
            (start: CGPoint(r: 300, a: TAU_2), end: CGPoint(r: 40, a: TAU_2)),
            (start: CGPoint(r: 300, a: TAU_2 + 5.degrees), end: CGPoint(r: 40, a: TAU_2 + 5.degrees)),
            (start: CGPoint(r: 300, a: TAU_2 + 10.degrees), end: CGPoint(r: 40, a: TAU_2 + 10.degrees)),
            (start: CGPoint(r: 375, a: TAU_2), end: CGPoint(r: 70, a: TAU_2)),
            (start: CGPoint(r: 375, a: TAU_2 + 5.degrees), end: CGPoint(r: 70, a: TAU_2 + 5.degrees)),
            (start: CGPoint(r: 375, a: TAU_2 + 10.degrees), end: CGPoint(r: 70, a: TAU_2 + 10.degrees)),
        ]
        showEnemies(enemies)

        moveCamera(to: CGPoint(x: -40, y: 0), handler: showSecondButton)
    }

    func showSecondButton() {
        let holdStart = drone.position
        let holdEnd = holdStart + CGPoint(x: -60, y: 40)
        let holdButton = Button(at: holdStart)
        holdButton.style = .CircleSized(70)
        holdButton.font = .Small
        holdButton.text = "HOLD"
        self << holdButton

        holdButton.touchableComponent!.onDragged { (prev_, location_) in
            var prev = self.convertPoint(prev_, fromNode: holdButton)
            var location = self.convertPoint(location_, fromNode: holdButton)
            prev.y = -2 * prev.x / 3
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingMoved(prev, location: location)

            if self.drone.placeholder.position.x < -70 {
                self.drone.draggableComponent!.draggingEnded(location)
                holdButton.removeFromParent()
            }
        }
        holdButton.touchableComponent!.on(.Down) { location_ in
            var location = self.convertPoint(location_, fromNode: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingBegan(location)
            holdButton.text = "DRAG"

            let moveTo = MoveToComponent()
            moveTo.target = holdEnd
            moveTo.speed = 100
            holdButton.addComponent(moveTo)
        }
        holdButton.touchableComponent!.on(.Up) { location_ in
            var location = self.convertPoint(location_, fromNode: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingEnded(location)
            holdButton.text = "HOLD"
            holdButton.moveToComponent?.removeFromNode()
        }

        onNoMoreEnemies {
            holdButton.removeFromParent()
            self.done()
        }
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
