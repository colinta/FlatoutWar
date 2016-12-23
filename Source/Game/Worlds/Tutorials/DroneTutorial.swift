////
///  DroneTutorial.swift
//

class DroneTutorial: Tutorial {
    let drone = DroneNode()

    override func populateWorld() {
        super.populateWorld()

        playerNode.rotateTo(TAU_2)
        tutorialTextNode.text = "DODEC DRONE"

        showWhy([
            "I FOUND AN ALLY! THIS DRONE MOVES",
            "AND SHOOTS IN ANY DIRECTION"
            ])

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
        moveTo.speed = HasUpgrade.False.droneMovementSpeed
        moveTo.onArrived(showTapButton)
        moveTo.removeComponentOnArrived()
        drone.addComponent(moveTo)
    }

    func showTapButton() {
        let tapButton = Button(at: drone.position + CGPoint(y: -10))
        tapButton.style = .Circle
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
        let enemies = showEnemies(at: [(start: CGPoint(r: 250, a: 0.degrees), end: CGPoint(r: 60, a: 0.degrees))])
        let enemyNode = enemies.first!

        let holdStart = drone.position + CGPoint(x: 80, y: -10)
        let holdEnd = holdStart + CGPoint(x: 60)
        let holdButton = Button(at: holdStart)
        holdButton.style = .CircleSized(70)
        holdButton.text = "HOLD"
        self << holdButton

        holdButton.touchableComponent!.onDragged { (prev_, location_) in
            var prev = self.convert(prev_, from: holdButton)
            var location = self.convert(location_, from: holdButton)
            prev.y = 0
            location.y = 0
            self.drone.draggableComponent?.draggingMoved(from: prev, to: location)

            if self.drone.placeholder.position.x > 60 {
                self.drone.draggableComponent!.draggingEnded(at: location)
                holdButton.removeFromParent()
            }
        }
        holdButton.touchableComponent!.on(.Down) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = 0
            self.drone.draggableComponent?.draggingBegan(at: location)
            holdButton.text = "DRAG"

            let moveTo = MoveToComponent()
            moveTo.target = holdEnd
            moveTo.speed = 80
            moveTo.onArrived() {
                if let isDragMoving = holdButton.draggableComponent?.isDragMoving,
                    !isDragMoving
                {
                    holdButton.removeFromParent()
                }
            }
            holdButton.addComponent(moveTo)
        }
        holdButton.touchableComponent!.on(.Up) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = 0
            self.drone.draggableComponent?.draggingEnded(at: location)
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
        closeButton.visible = true

        let moveTo = MoveToComponent()
        moveTo.target = CGPoint(x: 30, y: -60)
        moveTo.speed = HasUpgrade.False.droneMovementSpeed
        moveTo.removeComponentOnArrived()
        drone.addComponent(moveTo)
        playerNode.startRotatingTo(angle: 0)

        let enemies = [
            (start: CGPoint(r: 300, a: TAU_2), end: CGPoint(r: 40, a: TAU_2)),
            (start: CGPoint(r: 300, a: TAU_2 + 5.degrees), end: CGPoint(r: 40, a: TAU_2 + 5.degrees)),
            (start: CGPoint(r: 300, a: TAU_2 + 10.degrees), end: CGPoint(r: 40, a: TAU_2 + 10.degrees)),
            (start: CGPoint(r: 375, a: TAU_2), end: CGPoint(r: 70, a: TAU_2)),
            (start: CGPoint(r: 375, a: TAU_2 + 5.degrees), end: CGPoint(r: 70, a: TAU_2 + 5.degrees)),
            (start: CGPoint(r: 375, a: TAU_2 + 10.degrees), end: CGPoint(r: 70, a: TAU_2 + 10.degrees)),
        ]
        showEnemies(at: enemies)

        moveCamera(to: CGPoint(x: -40, y: 0), handler: showSecondButton)
    }

    func showSecondButton() {
        let holdStart = drone.position
        let holdEnd = holdStart + CGPoint(x: -60, y: 40)
        let holdButton = Button(at: holdStart)
        holdButton.style = .CircleSized(70)
        holdButton.text = "HOLD"
        self << holdButton

        holdButton.touchableComponent!.onDragged { (prev_, location_) in
            var prev = self.convert(prev_, from: holdButton)
            var location = self.convert(location_, from: holdButton)
            prev.y = -2 * prev.x / 3
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingMoved(from: prev, to: location)

            if self.drone.placeholder.position.x < -70 {
                self.drone.draggableComponent!.draggingEnded(at: location)
                holdButton.removeFromParent()
            }
        }
        holdButton.touchableComponent!.on(.Down) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingBegan(at: location)
            holdButton.text = "DRAG"

            let moveTo = MoveToComponent()
            moveTo.target = holdEnd
            moveTo.speed = 100
            holdButton.addComponent(moveTo)
        }
        holdButton.touchableComponent!.on(.Up) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingEnded(at: location)
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
