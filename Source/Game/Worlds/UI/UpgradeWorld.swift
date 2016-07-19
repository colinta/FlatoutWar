////
///  UpgradeWorld.swift
//

class UpgradeWorld: UIWorld {
    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: LevelConfig { return nextWorld.config }

    var playerNode: BasePlayerNode!
    var armyNodes: [Node] = []
    let mainLayer = Node()

    var powerupTargetButton: PowerupUpgradeButton!
    var powerupButtons: [PowerupUpgradeButton] = []
    let powerupLayer = Node()

    let upgradeTowerLayer = Node()
    let purchaseTowerLayer = Node()

    var gainedResources: TextNode!
    var gainedExperience: TextNode!

    func saveAndExit() {
    }

    func generateBackButton() -> Button {
        let back = Button()
        back.alignment = .Left
        back.position = CGPoint(x: -size.width / 2 + 15, y: size.height / 2 - 30)
        back.text = "< BACK"
        return back
    }

    func generateDoneButton() -> Button {
        let done = Button()
        done.alignment = .Left
        done.position = CGPoint(x: size.width / 2 + 15, y: size.height / 2 - 30)
        done.text = "DONE >"
        done.onTapped(saveAndExit)
        return done
    }

    func generatePowerupButton(powerup: Powerup, includeCount: Bool = true, includeCost: Bool = false) -> PowerupUpgradeButton {
        let powerupButton = PowerupUpgradeButton(powerup: powerup, includeCount: includeCount, includeCost: includeCost)
        return powerupButton
    }

    override func populateWorld() {
        super.populateWorld()

        levelConfig.storedPlayers = [BasePlayerNode(), DroneNode()]
        for node in levelConfig.storedPlayers {
            if let node = node as? BasePlayerNode {
                playerNode = node
            }
            else {
                armyNodes << node
            }
        }

        mainLayer << generateDoneButton()
        self << mainLayer

        do {
            powerupLayer.alpha = 0
            self << powerupLayer
        }

        do {
            upgradeTowerLayer << generateBackButton()
            upgradeTowerLayer.alpha = 0
            self << upgradeTowerLayer
        }

        do {
            purchaseTowerLayer << generateBackButton()
            purchaseTowerLayer.alpha = 0
            self << purchaseTowerLayer
        }

        let title = TextNode()
        title.font = .Big
        title.text = "ARMORY"
        title.position = CGPoint(y: size.height / 2 - 22)
        uiLayer << title

        let (gainedResources, gainedExperience) = populateCurrencies(config)
        self.gainedResources = gainedResources
        self.gainedExperience = gainedExperience

        showMainScreen()

        fadeTo(1, start: 0, duration: 0.5)
    }

    func showMainScreen() {
        let purchase = Button()
        purchase.style = .Circle
        purchase.text = "+"
        mainLayer << purchase

        playerNode.position = .zero
        playerNode.disableTouchForUI()
        let playerNodeButton = Button()
        playerNodeButton.style = .Circle
        playerNodeButton << playerNode
        mainLayer << playerNodeButton

        var angle = 7 * TAU_12
        let buttonRadius: CGFloat = 80
        let deltaAngle = TAU / CGFloat(armyNodes.count + 1)
        for armyNode in armyNodes {
            let position = CGPoint(r: buttonRadius, a: angle)

            armyNode.touchableComponent?.enabled = false

            let armyNodeButton = Button()
            armyNodeButton.position = position
            armyNodeButton.style = .Circle
            armyNodeButton << armyNode
            mainLayer << armyNodeButton

            angle += deltaAngle
        }

        let position = CGPoint(r: buttonRadius, a: angle)
        purchase.position = position

        let x: CGFloat = -size.width / 2 + 40
        var y: CGFloat = size.height / 2 - 40
        let dy: CGFloat = 80
        for powerup in levelConfig.activatedPowerups {
            let powerupButton = generatePowerupButton(powerup)
            powerupButton.position = CGPoint(x, y)
            mainLayer << powerupButton
            powerupButton.onTapped {
                self.showPowerupUpgrade(powerup, powerupButton: powerupButton)
            }

            y -= dy
        }
    }

    func showPowerupUpgrade(powerup: Powerup, powerupButton: PowerupUpgradeButton) {
        mainLayer.interactive = false
        powerupButton.enabled = false
        let startPosition = powerupButton.position
        let dest = CGPoint(y: -10)

        let powerupTarget = generatePowerupButton(powerup)
        powerupTarget.moveTo(dest, start: startPosition, duration: 1)
        uiLayer << powerupTarget
        powerupTargetButton = powerupTarget

        let animationDuration: CGFloat = 1
        mainLayer.fadeTo(0, duration: animationDuration / 2).onFaded {
            self.powerupLayer.interactive = true
            self.powerupLayer.fadeTo(1, duration: animationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let back = generateBackButton()
        back.onTapped {
            powerupTarget.moveTo(startPosition, duration: 1).onArrived {
                powerupButton.enabled = true
                powerupTarget.removeFromParent()
            }

            self.closePowerupLayer()
        }
        powerupLayer << back

        powerupButtons = []
        let purchaseablePowerups = [powerup.clone()] + levelConfig.purchaseablePowerups
        var angle: CGFloat = TAU_4
        let buttonRadius: CGFloat = 90
        let deltaAngle = TAU / CGFloat(purchaseablePowerups.count)
        for purchaseablePowerup in purchaseablePowerups {
            if purchaseablePowerup == powerup {
                purchaseablePowerup.count += 1
            }

            let powerupButton = generatePowerupButton(purchaseablePowerup, includeCount: false, includeCost: true)
            let p0 = dest + CGPoint(r: 2 * buttonRadius, a: angle)
            let p1 = dest + CGPoint(r: buttonRadius, a: angle)
            powerupButton.moveTo(p1, start: p0, duration: animationDuration)
            powerupButton.enabled = purchaseablePowerup.nextResourceCost != nil
            powerupLayer << powerupButton

            powerupButton.onTapped {
                self.powerupSelected(purchaseablePowerup)
            }

            powerupButtons << powerupButton
            angle += deltaAngle
        }
    }

    var prevSelectedPowerup: (Powerup, Node)?
    func powerupSelected(powerup: Powerup) {
        let prevPowerup = prevSelectedPowerup?.0
        let prevLayer = prevSelectedPowerup?.1
        let start = CGPoint(x: size.width / 2 + 80)
        let dest = CGPoint(x: size.width / 2 - 60)

        if let prevLayer = prevLayer {
            prevLayer.moveTo(start, duration: 0.3)
        }

        if prevPowerup == powerup {
            powerupTargetButton.offTapped()
            powerupTargetButton.restoreOriginal()
            powerupTargetButton.setScale(1)
            powerupTargetButton.background = nil
            prevSelectedPowerup = nil
            return
        }

        if let cost = powerup.nextResourceCost
        where cost < config.availableCurrency
        {
            powerupTargetButton.currentPowerup = powerup
            powerupTargetButton.setScale(1.1)
            powerupTargetButton.background = AllowedColor
        }
        else {
            powerupTargetButton.setScale(1)
            powerupTargetButton.background = NotAllowedColor
        }

        let layer = Node()
        powerupLayer << layer

        let powerupIcon = powerup.icon()
        powerupIcon.position = CGPoint(y: 50)
        layer << powerupIcon

        let tryButton = Button()
        tryButton.style = .RectToFit
        tryButton.text = "TRY >"
        tryButton.onTapped {
            self.powerupDemo(powerup.clone())
        }
        layer << tryButton

        layer.moveTo(dest, start: start, duration: 0.3)
        prevSelectedPowerup = (powerup, layer)
    }

    func powerupDemo(powerup: Powerup) {
        for layer in [powerupLayer, uiLayer] {
            layer.fadeTo(0, duration: 0.5)
            layer.moveTo(CGPoint(x: -100), duration: 0.5)
        }

        let layer = Node()
        layer.fadeTo(1, start: 0, duration: 0.5)
        self << layer

        let back = generateBackButton()
        back.onTapped {
            layer.fadeTo(0, duration: 0.5, removeNode: true)
            for layer in [self.powerupLayer, self.uiLayer] {
                layer.fadeTo(1, duration: 0.5)
                layer.moveTo(.zero, duration: 0.5)
            }
        }
        layer << back

        let playerNode = BasePlayerNode()
        playerNode.position = CGPoint(-200, -120)
        let touchableComponent = TouchableComponent()
        playerNode.addComponent(touchableComponent)
        defaultNode = playerNode
        layer << playerNode

        powerup.level = self
        powerup.playerNode = playerNode

        let button = generatePowerupButton(powerup)
        button.position = CGPoint(-200, 0)
        button.onTapped {
            button.enabled = false
            powerup.activate(self, layer: layer, playerNode: playerNode) {
                button.enabled = true
            }
        }
        layer << button

        powerup.demo(layer, playerNode: playerNode, timeline: timeline)
    }

    func closePowerupLayer() {
        if let prevPowerup = prevSelectedPowerup?.0 {
            powerupSelected(prevPowerup)
        }

        self << mainLayer
        self.powerupTargetButton = nil
        powerupLayer.interactive = false
        let animationDuration: CGFloat = 1
        powerupLayer.fadeTo(0, duration: animationDuration / 2).onFaded {
            self.mainLayer.interactive = true
            self.powerupLayer.removeAllChildren()
            self.mainLayer.fadeTo(1, duration: animationDuration / 2)
        }
    }

}
