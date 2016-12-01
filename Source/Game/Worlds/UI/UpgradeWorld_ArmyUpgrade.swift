////
///  UpgradeWorld_ArmyUpgrade.swift
//

extension UpgradeWorld {

    func showArmyUpgrade(armyButton originalArmyButton: ArmyUpgradeButton) {
        mainLayer.interactive = false
        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.upgradeArmyLayer.interactive = true
            self.upgradeArmyLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let upgradeable = originalArmyButton.node as! UpgradeableNode
        title.text = upgradeable.upgradeTitle()
        let armyUpgrades = upgradeable.availableUpgrades(world: self)

        let originalArmyNode = originalArmyButton.node
        originalArmyButton.alpha = 0
        let armyCurrentNode = Button(at: originalArmyButton.position)
        armyCurrentNode.interactive = false
        armyCurrentNode.style = .Circle
        originalArmyNode.move(toParent: armyCurrentNode, preservePosition: true)
        armyCurrentNode.moveTo(CGPoint(x: -size.width / 2 + 90), duration: PurchaseAnimationDuration)
        uiLayer << armyCurrentNode

        let backButton = generateBackButton()
        backButton.onTapped {
            self.closeArmyLayer(originalArmyButton: originalArmyButton, originalArmyNode: originalArmyNode, armyCurrentNode: armyCurrentNode)
        }
        upgradeArmyLayer << backButton

        let upgradeButtonsScroll = ScrollNode()
        upgradeButtonsScroll.contentInsets.top = 50
        upgradeButtonsScroll.contentInsets.bottom = 20
        upgradeButtonsScroll.fixedX = true
        defaultNode = upgradeButtonsScroll
        upgradeArmyLayer << upgradeButtonsScroll

        for (index, (upgradeButton, info)) in armyUpgrades.enumerated() {
            upgradeButton.position = positionForUpgradeButton(index: index, state: .Inactive)
            upgradeButton.alpha = 0
            upgradeButtonsScroll.content << upgradeButton

            timeline.after(time: PurchaseAnimationDuration / 2) {
                upgradeButton.moveTo(self.positionForUpgradeButton(index: index, state: .Active),
                                     duration: PurchaseAnimationDuration / 2)
                upgradeButton.fadeTo(upgradeButton.enabled ? 1 : ButtonDisabledAlpha, duration: PurchaseAnimationDuration / 2)
            }

            upgradeButton.onTapped {
                let allButtons = armyUpgrades.map { $0.0 }
                self.upgradePrompt(originalArmyNode: originalArmyNode, info: info, button: upgradeButton, allButtons: allButtons, backButton: backButton, restoreDefault: upgradeButtonsScroll)
            }
        }
    }

    func upgradePrompt(originalArmyNode: Node, info: UpgradeInfo, button upgradeButton: ArmyUpgradeButton, allButtons: [Button], backButton: Button, restoreDefault: Node?) {
        for (index, button) in allButtons.enumerated() {
            button.enabled = false
            button.fadeTo(0, duration: ButtonAnimationDuration)
            let dest = positionForUpgradeButton(index: index, state: .Inactive)
            button.moveTo(dest, duration: ButtonAnimationDuration)
        }

        let upgradePromptLayer = Node()

        let upgradeIcon = originalArmyNode.clone()
        ArmyUpgradeButton.disableNode(upgradeIcon)
        (upgradeIcon as! UpgradeableNode).applyUpgrade(type: info.upgradeType)
        upgradeIcon.position = positionForUpgradeButton(index: 0, state: .Selecting)
        upgradePromptLayer << upgradeIcon

        let anchor = CGPoint(y: -30)
        let tryButton = Button(at: anchor)
        tryButton.style = .RectToFit
        tryButton.margins.left = 5
        tryButton.text = "TRY >"
        tryButton.onTapped {
            let clone = originalArmyNode.clone()
            clone.playerComponent!.targetable = true
            (clone as! UpgradeableNode).applyUpgrade(type: info.upgradeType)
            self.upgradeDemo(armyNode: clone, info: info)
        }
        upgradePromptLayer << tryButton

        let purchaseButton = Button(at: anchor + CGPoint(y: -50))
        purchaseButton.style = .CircleSized(30)
        purchaseButton.text = "$"
        purchaseButton.enabled = config.canAfford(info.cost)
        purchaseButton.onTapped {
            self.purchaseUpgradeTapped(originalArmyNode: originalArmyNode, info: info, backButton: backButton)
        }
        upgradePromptLayer << purchaseButton

        let costResources = ResourceCostText()
        costResources.cost = info.cost.resources
        costResources.position = CGPoint(x: 25)
        purchaseButton << costResources

        let costExperience = ExperienceCostText()
        costExperience.cost = info.cost.experience
        costExperience.position = CGPoint(x: costResources.size.width + 35)
        purchaseButton << costExperience

        let cancelButton = CancelButton(at: upgradeIcon.position + CGPoint(x: 50))
        upgradePromptLayer << cancelButton

        cancelButton.onTapped {
            for (index, button) in allButtons.enumerated() {
                button.enabled = true
                button.fadeTo(button.enabled ? 1 : ButtonDisabledAlpha, duration: ButtonAnimationDuration)
                let dest = self.positionForUpgradeButton(index: index, state: .Active)
                button.moveTo(dest, duration: ButtonAnimationDuration)
            }
            upgradePromptLayer.interactive = false
            upgradePromptLayer.fadeTo(0, duration: ButtonAnimationDuration, removeNode: true).onFaded {
                self.defaultNode = restoreDefault
            }
        }

        upgradePromptLayer.fadeTo(1, start: 0, duration: ButtonAnimationDuration)
        upgradeArmyLayer << upgradePromptLayer
    }

    func purchaseUpgradeTapped(originalArmyNode: Node, info: UpgradeInfo, backButton: Button) {
        guard config.canAfford(info.cost) else { return }

        (originalArmyNode as! UpgradeableNode).applyUpgrade(type: info.upgradeType)
        config.spent(info.cost)
        backButton.triggerTapped()

    }

    func upgradeDemo(armyNode: Node, info: UpgradeInfo) {
        let prevLayers = [upgradeArmyLayer, uiLayer]
        for layer in prevLayers {
            layer.fadeTo(0, duration: LayerAnimationDuration).onFaded {
                layer.removeFromParent(reset: false)
            }
            layer.moveTo(CGPoint(x: -100), duration: LayerAnimationDuration)
        }

        let layer = Node()
        layer.fadeTo(1, start: 0, duration: LayerAnimationDuration)
        self << layer

        let title = TextNode()
        title.font = .Big
        title.text = info.title
        title.position = CGPoint(y: size.height / 2 - 22)
        layer << title

        armyNode.position = .zero
        defaultNode = armyNode
        layer << armyNode

        var y: CGFloat = 15
        for text in info.description {
            let label = TextNode(fixed: .BottomLeft(x: 10, y: y))
            label.text = text
            label.alignment = .left
            layer << label
            y += 30
        }

        timeline.every((info.rate - 0.4)...(info.rate + 0.4)) {
            2.times {
                let angle: CGFloat = rand(TAU)
                let enemyNode = EnemySoldierNode()
                enemyNode.name = "soldier"
                enemyNode.position = CGPoint(r: 250 ± rand(25), a: angle)
                enemyNode.fadeTo(1, start: 0, duration: 0.3)
                layer << enemyNode
            }
        }

        let backButton = generateBackButton()
        backButton.onTapped {
            layer.fadeTo(0, duration: LayerAnimationDuration, removeNode: true)
            for layer in prevLayers {
                self << layer
                layer.fadeTo(1, duration: LayerAnimationDuration)
                layer.moveTo(.zero, duration: LayerAnimationDuration)
            }
        }
        layer << backButton
    }

    func closeArmyLayer(originalArmyButton: ArmyUpgradeButton, originalArmyNode: Node, armyCurrentNode: Node) {
        armyCurrentNode.move(toParent: uiLayer, preservePosition: true)
        originalArmyButton.move(toParent: uiLayer, preservePosition: true)
        armyCurrentNode.moveTo(originalArmyButton.position, duration: PurchaseAnimationDuration).onArrived {
            originalArmyNode.move(toParent: originalArmyButton, preservePosition: true)
            armyCurrentNode.removeFromParent()
            originalArmyButton.alpha = 1
        }

        self << mainLayer
        self.willShowMain()
        defaultNode = nil
        upgradeArmyLayer.interactive = false

        upgradeArmyLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.upgradeArmyLayer.removeAllChildren()

            self.mainLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2).onFaded {
                originalArmyButton.move(toParent: self.mainLayer, preservePosition: true)
                self.mainLayer.interactive = true
            }
        }
    }

}
