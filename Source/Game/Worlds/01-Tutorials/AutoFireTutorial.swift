////
///  AutoFireTutorial.swift
//

class AutoFireTutorial: Tutorial {
    let experiencePercent = ExperiencePercent(goal: 5)

    override func didAdd(_ node: Node) {
        super.didAdd(node)
        if let enemyComponent = node.enemyComponent,
            let healthComponent = node.healthComponent
        {
            healthComponent.onKilled {
                self.experiencePercent.gain(enemyComponent.experience)
            }
        }
    }

    override func populateWorld() {
        super.populateWorld()

        experiencePercent.fixedPosition = .bottomRight(x: -35, y: 30)
        ui << experiencePercent
        tutorialTextNode.text = "AUTO AIM"

        timeline.at(1) {
            self.showWhy([
                "DESTROY ENEMIES FOR EXPERIENCE",
                "AND TO PURCHASE UPGRADES",
            ])
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
        showEnemies(at: enemyLocations)
    }

    func showFirstButton() {
        let tapButton = Button(at: CGPoint(x: 0, y: -50))
        tapButton.style = .circle
        tapButton.text = "TAP"
        tapButton.touchableComponent?.on(.tapped) { tapLocation in
            let location = self.playerNode.convertPosition(tapButton) + tapLocation
            self.playerNode.rotateToComponent?.target = location.angle
        }

        onNoMoreEnemies {
            self.playerNode.enemyTargetingComponent?.currentTarget = nil
            tapButton.removeFromParent()
            self.showSecondEnemies()
        }

        self << tapButton
        defaultNode = tapButton
    }

    func showSecondEnemies() {
        tutorialTextNode.text = "NICE!"
        closeButton.visible = true

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

        timeline.after(time: 1) {
            self.showSecondButton()
        }
    }

    func showSecondButton() {
        let tapButton = Button(at: CGPoint(x: 150, y: 0))
        tapButton.style = .circle
        tapButton.text = "TAP"

        tapButton.touchableComponent?.on(.tapped) { tapLocation in
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
