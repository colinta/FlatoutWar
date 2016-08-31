////
///  UpgradeWorld_Powerups.swift
//

private let PurchaseAnimationDuration: CGFloat = 1
private let ButtonAnimationDuration: CGFloat = 0.5
private let LayerAnimationDuration: CGFloat = 0.3


extension UpgradeWorld {
    func showPowerupUpgrade(mainButton mainPowerupButton: PowerupUpgradeButton) {
        let assignedPowerup = mainPowerupButton.powerup
        mainLayer.interactive = false
        mainPowerupButton.enabled = false
        let startPosition = mainPowerupButton.position
        let dest = CGPoint(x: startPosition.x + 50)

        let tempPowerupButton = generatePowerupButton(assignedPowerup)
        tempPowerupButton.enabled = false
        tempPowerupButton.alpha = 1
        tempPowerupButton.moveTo(dest, start: startPosition, speed: 150)
        uiLayer << tempPowerupButton

        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.powerupLayer.interactive = true
            self.powerupLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let back = generateBackButton()
        back.onTapped {
            self.closePowerupLayer(tempButton: tempPowerupButton, mainButton: mainPowerupButton)
        }
        powerupLayer << back

        let powerupButtonScroll = ScrollNode()
        powerupButtonScroll.contentInsets.top = 40
        powerupButtonScroll.contentInsets.bottom = 20
        powerupButtonScroll.fixedX = true
        defaultNode = powerupButtonScroll
        powerupLayer << powerupButtonScroll

        var powerupButtons: [PowerupUpgradeButton] = []
        let purchaseablePowerups = [assignedPowerup] + levelConfig.purchaseablePowerups
        for (index, purchaseablePowerup) in purchaseablePowerups.enumerate() {
            let purchaseablePowerupButton = generatePowerupButton(purchaseablePowerup, includeCount: true, includeCost: true)
            let p0 = positionForPurchaseablePowerupButton(index: index, count: purchaseablePowerups.count, state: .Enter)
            let p1 = positionForPurchaseablePowerupButton(index: index, count: purchaseablePowerups.count, state: .Default)
            purchaseablePowerupButton.moveTo(p1, start: p0, duration: PurchaseAnimationDuration)
            purchaseablePowerupButton.enabled = purchaseablePowerup.nextResourceCost != nil
            if purchaseablePowerup.count > 0 {
                purchaseablePowerupButton.powerupCountNode?.color = AllowedColor
            }
            powerupButtonScroll.content << purchaseablePowerupButton
            powerupButtons << purchaseablePowerupButton

            purchaseablePowerupButton.onTapped {
                self.powerupSelected(
                    purchaseablePowerup,
                    tempButton: tempPowerupButton,
                    mainButton: mainPowerupButton,
                    purchaseButton: purchaseablePowerupButton,
                    allButtons: powerupButtons)
            }
        }
    }

    private enum PurchaseState {
        case Enter
        case Default
        case Purchasing
        case Selecting
    }
    private func positionForPurchaseablePowerupButton(
        index index: Int,
        count: Int,
        state: PurchaseState
        ) -> CGPoint
    {
        let center = CGPoint(125, 90)
        let dy: CGFloat = -65
        let dx: CGFloat = 30

        switch state {
        case .Default:
            return center + CGPoint(y: dy * CGFloat(index))
        case .Enter, .Purchasing:
            return center + CGPoint(dx, dy * CGFloat(index))
        case .Selecting:
            return CGPoint(y: 60)
        }
    }

    func unselectPowerup(allButtons allPowerupButtons: [PowerupUpgradeButton]? = nil) {
        guard let prevLayer = prevSelectedPowerupLayer else { return }

        defaultNode?.touchableComponent?.enabled = true
        prevSelectedPowerupLayer = nil
        prevLayer.fadeTo(0, duration: LayerAnimationDuration)
        if let allPowerupButtons = allPowerupButtons {
            for (index, button) in allPowerupButtons.enumerate() {
                button.enabled = true
                button.fadeTo(1, duration: ButtonAnimationDuration)
                button.moveTo(positionForPurchaseablePowerupButton(index: index, count: allPowerupButtons.count, state: .Default), duration: ButtonAnimationDuration)
            }
        }
    }

    func powerupSelected(
        powerup: Powerup,
        tempButton tempPowerupButton: PowerupUpgradeButton,
        mainButton mainPowerupButton: PowerupUpgradeButton,
        purchaseButton purchaseablePowerupButton: PowerupUpgradeButton,
        allButtons allPowerupButtons: [PowerupUpgradeButton]
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
        for (index, button) in allPowerupButtons.enumerate() {
            if button.powerup == mainPowerupButton.powerup {
                myIndex = index
            }
            let dest = positionForPurchaseablePowerupButton(index: index, count: allPowerupButtons.count, state: .Purchasing)
            button.moveTo(dest, duration: ButtonAnimationDuration)
            button.fadeTo(0.5, duration: ButtonAnimationDuration)
            button.enabled = false
        }

        let powerupIcon = powerup.icon()
        powerupIcon.position = positionForPurchaseablePowerupButton(index: myIndex, count: allPowerupButtons.count, state: .Selecting)
        tryPowerupLayer << powerupIcon

        let cancelButton = Button(at: CGPoint(x: 50, y: 60))
        cancelButton.style = .CircleSized(50)
        cancelButton.setScale(0.5)
        cancelButton.font = .Big
        cancelButton.text = "×"
        cancelButton.onTapped {
            self.unselectPowerup(allButtons: allPowerupButtons)
        }
        tryPowerupLayer << cancelButton

        let tryButton = Button(at: CGPoint(x: 5))
        tryButton.style = .RectToFit
        tryButton.margins.left = 5
        tryButton.alignment = .Left
        tryButton.text = "TRY >"
        tryButton.onTapped {
            self.powerupDemo(powerup.clone())
        }
        tryPowerupLayer << tryButton

        let assignButton = Button(at: CGPoint(x: -5))
        assignButton.style = .RectToFit
        assignButton.margins.right = 5
        assignButton.alignment = .Right
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
        purchaseButton.text = "+"
        tryPowerupLayer << purchaseButton

        let resourceSquare = SKSpriteNode(id: .ResourceIcon)
        resourceSquare.position = purchaseButton.position + CGPoint(x: 25)
        tryPowerupLayer << resourceSquare

        let purchasedText = PurchasedTextNode(at: CGPoint(y: -90))
        purchasedText.max = powerup.nextResourceCosts.count
        purchasedText.purchased = powerup.count
        tryPowerupLayer << purchasedText

        let costResources = TextNode()
        if let cost = powerup.nextResourceCost {
            costResources.text = "\(cost.resources)"
            costResources.position = purchaseButton.position + CGPoint(x: 35)
            costResources.alignment = .Left
            tryPowerupLayer << costResources
        }

        if let cost = powerup.nextResourceCost
        where config.canAfford(cost)
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
        powerup: Powerup,
        _ assignButton: Button,
        _ tempPowerupButton: PowerupUpgradeButton,
        _ mainPowerupButton: PowerupUpgradeButton,
        _ purchaseablePowerupButton: PowerupUpgradeButton,
        _ purchaseButton: Button,
        _ costResources: TextNode,
        _ purchasedText: PurchasedTextNode
        )
    {
        guard let cost = powerup.nextResourceCost
            where self.config.canAfford(cost) else { return }

        assignButton.enabled = tempPowerupButton.powerup != powerup
        self.config.spent(cost)
        powerup.count += 1
        self.levelConfig.updatePowerup(powerup)
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
            costResources.text = "\(cost.resources)"
        }
        else {
            purchaseButton.background = NotAllowedColor
            purchaseButton.enabled = false
            purchaseButton.offTapped()
            costResources.removeFromParent()
        }
    }

    func powerupDemo(powerup: Powerup) {
        for layer in [powerupLayer, uiLayer] {
            layer.fadeTo(0, duration: 0.5)
            layer.moveTo(CGPoint(x: -100), duration: 0.5)
        }

        let layer = Node()
        layer.fadeTo(1, start: 0, duration: 0.5)
        self << layer

        let playerNode = BasePlayerNode()
        playerNode.position = CGPoint(-200, -100)
        let touchableComponent = TouchableComponent()
        playerNode.addComponent(touchableComponent)
        defaultNode = playerNode
        layer << playerNode

        powerup.level = self
        powerup.playerNode = playerNode

        let button = generatePowerupButton(powerup)
        button.position = CGPoint(-200, 50)
        button.onTapped {
            button.enabled = false
            powerup.activate(self, layer: layer, playerNode: playerNode) {
                button.enabled = true
            }
        }
        layer << button

        let cancelDemo = powerup.demo(layer, playerNode: playerNode, timeline: timeline)

        let back = generateBackButton()
        back.onTapped {
            cancelDemo()
            layer.fadeTo(0, duration: 0.5, removeNode: true)
            for layer in [self.powerupLayer, self.uiLayer] {
                layer.fadeTo(1, duration: 0.5)
                layer.moveTo(.zero, duration: 0.5)
            }
        }
        layer << back
    }

    func closePowerupLayer(tempButton tempPowerupButton: Button, mainButton mainPowerupButton: Button) {
        unselectPowerup()

        self << mainLayer
        defaultNode = nil
        powerupLayer.interactive = false

        tempPowerupButton.enabled = false
        mainPowerupButton.enabled = true
        tempPowerupButton.moveToParent(self, preservePosition: true)
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
