////
///  DroneTutorial.swift
//

class DroneTutorial: Tutorial {
    let drone = DroneNode()

    override func populateWorld() {
        super.populateWorld()

        playerNode.firingComponent?.enabled = false
        playerNode.setRotation(TAU_2)
        tutorialTextNode.text = "DODEC DRONE"

        showWhy([
            "I FOUND AN ALLY! THIS DRONE MOVES",
            "AND SHOOTS IN ANY DIRECTION"
            ])

        timeline.at(1, block: showDrone)
    }

    func showDrone() {
        drone.position = CGPoint(r: 50, a: -TAU_12)
        drone.alpha = 0
        drone.touchableEnabled = false
        drone.wanderingEnabled = false
        drone.draggableComponent?.maintainDistance(100, around: playerNode)
        self << drone

        let fadeIn = FadeToComponent()
        fadeIn.target = 1
        fadeIn.duration = 1.4
        fadeIn.removeComponentOnFade()
        fadeIn.onFaded(showTapButton)
        drone.addComponent(fadeIn)
    }

    func showTapButton() {
        let textNode = TextNode()
        textNode.text = "TAP TO SELECT"
        self << textNode

        let tapButton = Button(at: drone.position)
        textNode.position = tapButton.position + CGPoint(y: -85)
        tapButton.style = .circle
        tapButton.textSprite.position = CGPoint(y: -10)
        tapButton.onTapped {
            textNode.removeFromParent()
            tapButton.removeFromParent()
            self.showFirstDemo()
        }
        self << tapButton
    }

    func showFirstDemo() {
        self.selectNode(self.drone)

        showWhy([
            "DRAG ANYWHERE TO MOVE"
            ])
        drone.touchableEnabled = nil
        defaultNode = drone

        let enemies = showEnemies(at: [(start: CGPoint(r: 250, a: 0.degrees), end: CGPoint(r: 60, a: 0.degrees))])
        let enemyNode = enemies.first!
        enemyNode.onDeath {
            self.showSecondDemo()
        }
    }

    func showSecondDemo() {
        self.unselectNode(drone)

        tutorialTextNode.text = "NICE!"
        closeButton.visible = true

        showWhy([
            "MOVE THE DRONE INTO POSITION"
            ])
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

        onNoMoreEnemies(done)

        moveCamera(to: CGPoint(x: -40, y: 0))
    }

    func showSecondButton() {
        let holdStart = drone.position
        let holdEnd = holdStart + CGPoint(x: -60, y: 40)
        let holdButton = Button(at: holdStart)
        holdButton.style = .circleSized(70)
        holdButton.text = "HOLD"
        self << holdButton

        holdButton.touchableComponent!.onDragged { (prev_, location_) in
            var prev = self.convert(prev_, from: holdButton)
            var location = self.convert(location_, from: holdButton)
            prev.y = -2 * prev.x / 3
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingMoved(from: prev, to: location)

            if let x = self.drone.placeholder?.position.x, x < -70 {
                self.drone.draggableComponent!.draggingEnded(at: location)
                holdButton.removeFromParent()
            }
        }
        holdButton.touchableComponent!.on(.down) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingBegan(at: location)
            holdButton.text = "DRAG"

            let moveTo = MoveToComponent()
            moveTo.target = holdEnd
            moveTo.speed = 100
            holdButton.addComponent(moveTo)
        }
        holdButton.touchableComponent!.on(.up) { location_ in
            var location = self.convert(location_, from: holdButton)
            location.y = -2 * location.x / 3
            self.drone.draggableComponent?.draggingEnded(at: location)
            holdButton.text = "HOLD"
            holdButton.moveToComponent?.removeFromNode()
        }
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
