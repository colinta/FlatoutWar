////
///  PowerupTutorial.swift
//

class PowerupTutorial: Tutorial {
    var powerups: [Powerup] = []
    var powerupButtons: [Button] = []
    var mines = 3

    override func populateWorld() {
        super.populateWorld()

        playerNode.firingComponent?.enabled = false
        playerNode.radarSprite.removeFromParent()
        playerNode.position += CGPoint(10, -10)
        tutorialTextNode.font = .small
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
        let cancel = timeline.cancellable.after(time: 3) {
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
        for (index, button) in powerupButtons.enumerated() {
            ui << button
            let start: Position = .left(
                x: -150,
                y: 80 - CGFloat(index) * 80
            )
            let dest: Position = .left(
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
        let position: Position = .left(
            x: 60,
            y: 100
        )

        let tapLabel = TextNode(fixed: position)
        tapLabel.text = "TAP ONE"

        ui << tapLabel
        return tapLabel
    }

    func chosePowerup(_ powerup: Powerup, position: CGPoint, button: Button) {
        for anyButton in powerupButtons {
            anyButton.enabled = false
        }

        powerup.activate(level: self, playerNode: self.playerNode) {
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
        let nextStep = afterAllWaves(nextWave: done)

        var delay: CGFloat = 0
        var nextDelay: CGFloat = 4
        10.times {
            let wave: CGFloat = TAU_7_8 ± rand(TAU_8)
            timeline.every(0.25, start: .after(delay), times: 3, block: self.generateEnemy(wave)) ~~> nextStep()
            delay += nextDelay
            nextDelay -= 0.15
        }
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

    var experience = 0
    func generateEnemy(_ genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemySoldierNode()
            enemyNode.healthComponent?.onKilled {
                self.experience += 1
                if self.experience == 10 {
                    self.nice()
                }
            }
            enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    func nice() {
        tutorialTextNode.text = "NICE!"
        closeButton.visible = true
    }

    override func update(_ dt: CGFloat) {
        super.update(dt)
        for powerup in powerups {
            powerup.update(dt)
        }
    }

}
