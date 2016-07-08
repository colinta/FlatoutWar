////
///  PowerupTutorial.swift
//

class PowerupTutorial: Tutorial {
    var powerups: [Powerup] = []
    var powerupButtons: [Button] = []
    var mines = 3
    var resourcePercent = ResourcePercent(max: 100)

    override func populateWorld() {
        super.populateWorld()

        resourcePercent.gain(100)
        ui << resourcePercent

        playerNode.firingComponent?.enabled = false
        playerNode.radarNode.removeFromParent()
        playerNode.position += CGPoint(10, -10)
        tutorialTextNode.font = .Small
        tutorialTextNode.text = "POWERUPS"

        timeline.at(1) {
            self.showPowerups()
        }
    }

    func showPowerups() {
        let powerups: [Powerup] = [
            GrenadePowerup(),
            LaserPowerup(),
            MinesPowerup(),
        ]
        self.powerups = powerups

        var tapLabel: SKNode?
        let cancel = timeline.cancellable.after(3) {
            tapLabel = self.showTapLabel()
        }

        for powerup in powerups {
            powerup.cancellable = false
            powerup.level = self
            powerup.playerNode = self
            let (button, icon) = powerup.buttonIcon()
            powerupButtons << button

            button.onTapped {
                cancel()
                tapLabel?.removeFromParent()
                self.chosePowerup(powerup, position: button.position + icon.position, button: button)
            }
        }

        let duration: CGFloat = 1
        for (index, button) in powerupButtons.enumerate() {
            ui << button
            let start: Position = .Left(
                x: -150,
                y: 80 - CGFloat(index) * 80
            )
            let dest: Position = .Left(
                x: 40,
                y: 50 - CGFloat(index) * 50
            )
            button.fixedPosition = start
            button.enabled = false
            let moveTo = button.moveTo(dest, duration: duration)
            moveTo.onArrived {
                button.enabled = true
            }
        }

        moveCamera(zoom: 1.0, duration: duration)
        releaseEnemies()
    }

    func showTapLabel() -> TextNode {
        let position: Position = .Left(
            x: 60,
            y: 100
        )

        let tapLabel = TextNode(fixed: position)
        tapLabel.text = "TAP ONE"

        ui << tapLabel
        return tapLabel
    }

    func chosePowerup(powerup: Powerup, position: CGPoint, button: Button) {
        for anyButton in powerupButtons {
            anyButton.enabled = false
        }

        if powerup.resourceCost < resourcePercent.collected {
            resourcePercent.spend(powerup.resourceCost)
        }
        else {
            resourcePercent.spend(resourcePercent.collected)
        }

        powerup.activate(self, playerNode: self.playerNode) {
            if powerup is MinesPowerup {
                self.mines -= 1
                if self.mines > 0 {
                    button.enabled = true
                }
            }
            else {
                button.enabled = true
            }

            for anyButton in self.powerupButtons where anyButton != button {
                anyButton.enabled = true
            }
        }
    }

    func releaseEnemies() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.done() }
        }

        var delay: CGFloat = 0
        var nextDelay: CGFloat = 4
        10.times {
            let wave: CGFloat = TAU_7_8 ± rand(TAU_8)
            timeline.every(0.25, start: .Delayed(delay), times: 3, block: self.generateEnemy(wave)) ~~> nextStep()
            delay += nextDelay
            nextDelay -= 0.15
        }

        showWhy([
            "POWERUPS REQUIRE RESOURCES",
        ])
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

    func generateEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    override func update(dt: CGFloat) {
        super.update(dt)
        for powerup in powerups {
            powerup.update(dt)
        }
    }

}
