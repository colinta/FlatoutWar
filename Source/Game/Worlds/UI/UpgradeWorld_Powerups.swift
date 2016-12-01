////
///  UpgradeWorld_Powerups.swift
//

extension UpgradeWorld {

    func showPowerupUpgrade(mainButton mainPowerupButton: PowerupUpgradeButton) {
        title.text = "POWERUP"
        mainLayer.interactive = false
        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.powerupLayer.interactive = true
            self.powerupLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let assignedPowerup = mainPowerupButton.powerup
        let startPosition = mainPowerupButton.position
        let dest = CGPoint(x: -size.width / 2 + 90)

        let tempPowerupButton = generatePowerupButton(assignedPowerup)
        tempPowerupButton.enabled = false
        tempPowerupButton.alpha = 1
        tempPowerupButton.moveTo(dest, start: startPosition, speed: 150)
        uiLayer << tempPowerupButton

        let backButton = generateBackButton()
        backButton.onTapped {
            self.closePowerupLayer(tempButton: tempPowerupButton, mainButton: mainPowerupButton)
        }
        powerupLayer << backButton

        let powerupButtonsScroll = ScrollNode()
        powerupButtonsScroll.contentInsets.top = 50
        powerupButtonsScroll.contentInsets.bottom = 20
        powerupButtonsScroll.fixedX = true
        defaultNode = powerupButtonsScroll
        powerupLayer << powerupButtonsScroll

        var powerupButtons: [PowerupUpgradeButton] = []
        let purchaseablePowerups = [assignedPowerup] + levelConfig.purchaseablePowerups
        for (index, purchaseablePowerup) in purchaseablePowerups.enumerated() {
            let purchaseablePowerupButton = generatePowerupButton(purchaseablePowerup, includeCount: true, includeCost: true)
            let p0 = positionForUpgradeButton(index: index, state: .Inactive)
            let p1 = positionForUpgradeButton(index: index, state: .Active)
            purchaseablePowerupButton.moveTo(p1, start: p0, duration: PurchaseAnimationDuration)
            purchaseablePowerupButton.enabled = purchaseablePowerup.nextResourceCost != nil
            if purchaseablePowerup.count > 0 {
                purchaseablePowerupButton.powerupCountNode?.color = AllowedColor
            }
            powerupButtonsScroll.content << purchaseablePowerupButton
            powerupButtons << purchaseablePowerupButton

            purchaseablePowerupButton.onTapped {
                self.powerupSelected(
                    powerup: purchaseablePowerup,
                    tempButton: tempPowerupButton,
                    mainButton: mainPowerupButton,
                    purchaseButton: purchaseablePowerupButton,
                    allButtons: powerupButtons,
                    restoreDefault: powerupButtonsScroll
                    )
            }
        }
    }

    func unselectPowerup(allButtons allPowerupButtons: [PowerupUpgradeButton]? = nil) {
        guard let prevLayer = prevSelectedPowerupLayer else { return }

        defaultNode?.touchableComponent?.enabled = true
        prevSelectedPowerupLayer = nil
        prevLayer.fadeTo(0, duration: LayerAnimationDuration)
        if let allPowerupButtons = allPowerupButtons {
            for (index, button) in allPowerupButtons.enumerated() {
                button.enabled = true
                button.fadeTo(1, duration: ButtonAnimationDuration)
                button.moveTo(positionForUpgradeButton(index: index, state: .Active), duration: ButtonAnimationDuration)
            }
        }
    }

    func powerupSelected(
        powerup: Powerup,
        tempButton tempPowerupButton: PowerupUpgradeButton,
        mainButton mainPowerupButton: PowerupUpgradeButton,
        purchaseButton purchaseablePowerupButton: PowerupUpgradeButton,
        allButtons allPowerupButtons: [PowerupUpgradeButton],
        restoreDefault: Node?
        )
    {
        guard prevSelectedPowerupLayer == nil else {
            unselectPowerup(allButtons: allPowerupButtons)
            return
        }

        let tryPowerupLayer = Node(at: CGPoint(y: 0))
        powerupLayer << tryPowerupLayer
        prevSelectedPowerupLayer = tryPowerupLayer
        defaultNode?.touchableComponent?.enabled = false

        var myIndex = 0
        for (index, button) in allPowerupButtons.enumerated() {
            if button.powerup == mainPowerupButton.powerup {
                myIndex = index
            }
            let dest = positionForUpgradeButton(index: index, state: .Inactive)
            button.moveTo(dest, duration: ButtonAnimationDuration)
            button.fadeTo(0, duration: ButtonAnimationDuration)
            button.enabled = false
        }

        let powerupIcon = powerup.icon()
        powerupIcon.position = positionForUpgradeButton(index: myIndex, state: .Selecting)
        tryPowerupLayer << powerupIcon

        let cancelButton = CancelButton(at: powerupIcon.position + CGPoint(x: 50))
        cancelButton.onTapped {
            self.defaultNode = restoreDefault
            self.unselectPowerup(allButtons: allPowerupButtons)
        }
        tryPowerupLayer << cancelButton

        let tryButton = Button(at: CGPoint(x: 5))
        tryButton.style = .RectToFit
        tryButton.margins.left = 5
        tryButton.alignment = .left
        tryButton.text = "TRY >"
        tryButton.onTapped {
            self.powerupDemo(powerup: powerup.clone())
        }
        tryPowerupLayer << tryButton

        let assignButton = Button(at: CGPoint(x: -5))
        assignButton.style = .RectToFit
        assignButton.margins.right = 5
        assignButton.alignment = .right
        assignButton.text = "< ASSIGN"
        assignButton.enabled = powerup.count > 0 && tempPowerupButton.powerup != powerup
        assignButton.onTapped {
            let prevPowerup = mainPowerupButton.powerup
            self.levelConfig.replacePowerup(prevPowerup, with: powerup)
            mainPowerupButton.powerup = powerup
            tempPowerupButton.powerup = powerup
            self.closePowerupLayer(tempButton: tempPowerupButton, mainButton: mainPowerupButton)
        }
        tryPowerupLayer << assignButton

        let purchaseButton = Button(at: CGPoint(y: -50))
        purchaseButton.style = .CircleSized(30)
        purchaseButton.text = "$"
        tryPowerupLayer << purchaseButton

        let purchasedText = PurchasedTextNode(at: CGPoint(y: -90))
        purchasedText.max = powerup.nextResourceCosts.count
        purchasedText.purchased = powerup.count
        tryPowerupLayer << purchasedText

        let costResources = ResourceCostText()
        costResources.position = CGPoint(x: 25)
        purchaseButton << costResources

        if let cost = powerup.nextResourceCost {
            costResources.cost = cost.resources
        }

        if let cost = powerup.nextResourceCost,
            config.canAfford(cost)
        {
            purchaseButton.onTapped { self.purchasePowerupTapped(
                powerup,
                assignButton,
                tempPowerupButton,
                mainPowerupButton,
                purchaseablePowerupButton,
                purchaseButton,
                costResources,
                purchasedText) }
        }
        else {
            purchaseButton.background = NotAllowedColor
            purchaseButton.enabled = false
        }

        tryPowerupLayer.fadeTo(1, start: 0, duration: LayerAnimationDuration)
    }

    func purchasePowerupTapped(
        _ powerup: Powerup,
        _ assignButton: Button,
        _ tempPowerupButton: PowerupUpgradeButton,
        _ mainPowerupButton: PowerupUpgradeButton,
        _ purchaseablePowerupButton: PowerupUpgradeButton,
        _ purchaseButton: Button,
        _ costResources: ResourceCostText,
        _ purchasedText: PurchasedTextNode
    ) {
        guard let cost = powerup.nextResourceCost,
            config.canAfford(cost)
        else {
            return
        }

        assignButton.enabled = tempPowerupButton.powerup != powerup
        config.spent(cost)
        powerup.count += 1
        levelConfig.updatePowerup(powerup)
        purchaseablePowerupButton.powerup = powerup
        purchaseablePowerupButton.powerupCountNode?.color = AllowedColor
        purchasedText.purchased = powerup.count

        if tempPowerupButton.powerup == powerup {
            tempPowerupButton.powerup = powerup
        }

        if mainPowerupButton.powerup == powerup {
            mainPowerupButton.powerup = powerup
        }

        if let cost = powerup.nextResourceCost {
            costResources.cost = cost.resources
        }
        else {
            purchaseButton.background = NotAllowedColor
            purchaseButton.enabled = false
            purchaseButton.offTapped()
            costResources.removeFromParent()
        }
    }

    func powerupDemo(powerup: Powerup) {
        let prevLayers = [powerupLayer, uiLayer]
        for layer in prevLayers {
            layer.fadeTo(0, duration: 0.5)
            layer.moveTo(CGPoint(x: -100), duration: 0.5)
        }

        let layer = Node()
        layer.fadeTo(1, start: 0, duration: 0.5)
        self << layer

        let playerNode = BasePlayerNode()
        playerNode.position = CGPoint(-200, -100)
        defaultNode = playerNode
        layer << playerNode

        powerup.level = self
        powerup.playerNode = playerNode

        let button = generatePowerupButton(powerup)
        button.position = CGPoint(-200, 50)
        button.onTapped {
            button.enabled = false
            powerup.activate(level: self, layer: layer, playerNode: playerNode) {
                button.enabled = true
            }
        }
        layer << button

        let cancelDemo = powerup.demo(layer: layer, playerNode: playerNode, timeline: timeline)

        let backButton = generateBackButton()
        backButton.onTapped {
            cancelDemo()
            layer.fadeTo(0, duration: 0.5, removeNode: true)
            for layer in prevLayers {
                layer.fadeTo(1, duration: 0.5)
                layer.moveTo(.zero, duration: 0.5)
            }
        }
        layer << backButton
    }

    func closePowerupLayer(tempButton tempPowerupButton: Button, mainButton mainPowerupButton: Button) {
        unselectPowerup()

        self << mainLayer
        self.willShowMain()
        defaultNode = nil
        powerupLayer.interactive = false

        tempPowerupButton.move(toParent: self, preservePosition: true)
        tempPowerupButton.moveTo(mainPowerupButton.position, speed: 150)
        powerupLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.powerupLayer.removeAllChildren()

            self.mainLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2).onFaded {
                self.mainLayer.interactive = true
                tempPowerupButton.removeFromParent()
            }
        }
    }
}
