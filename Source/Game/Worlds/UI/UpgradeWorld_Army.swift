////
///  UpgradeWorld_Army.swift
//

extension UpgradeWorld {

    func positionArmyButtons(playerNodeButton: ArmyUpgradeButton, armyButtons: [ArmyUpgradeButton], purchaseTower: Button) {
        playerNodeButton.onTapped { self.showArmyUpgrade(armyButton: playerNodeButton) }

        var angle = 7 * TAU_12
        let buttonRadius: CGFloat = 80
        let deltaAngle = TAU / 4
        for armyButton in armyButtons {
            let position = CGPoint(r: buttonRadius, a: angle)

            armyButton.position = position
            mainLayer << armyButton

            armyButton.onTapped { self.showArmyUpgrade(armyButton: armyButton) }

            angle += deltaAngle
        }

        let position = CGPoint(r: buttonRadius, a: angle)
        purchaseTower.position = position
        purchaseTower.style = .Circle
        purchaseTower.text = "+"
        purchaseTower.onTapped(showArmyPurchase)
        mainLayer << purchaseTower
    }

    private enum ArmyUpgradeState {
        case Enter
        case Default
    }
    private func positionForArmyUpgradeButton(
        index: Int,
        count: Int,
        state: ArmyUpgradeState
        ) -> CGPoint
    {
        guard state != .Enter else {
            return .zero
        }

        let positions: [CGPoint]
        if count <= 4 {
            positions = [
                CGPoint(r: 100, a: TAU_8),
                CGPoint(r: 100, a: TAU_3_8),
                CGPoint(r: 100, a: TAU_5_8),
                CGPoint(r: 100, a: TAU_7_8),
            ]
        }
        else {
            positions = []
        }

        return positions[index]
    }

    func showArmyUpgrade(armyButton originalArmyButton: ArmyUpgradeButton) {
        guard let
            armyUpgrades = (originalArmyButton.node as? UpgradeableNodes)?.availableUpgrades(world: self)
        else { return }

        originalArmyButton.alpha = 0
        let armyCenterNode = Button(at: originalArmyButton.position)
        armyCenterNode.interactive = false
        armyCenterNode.style = .Circle
        let armySprite = originalArmyButton.node
        armySprite.move(toParent: armyCenterNode)
        armySprite.position = .zero
        armyCenterNode.moveTo(.zero, duration: PurchaseAnimationDuration / 2)
        uiLayer << armyCenterNode

        mainLayer.interactive = false
        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.upgradeArmyLayer.interactive = true
            self.upgradeArmyLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        for (index, (upgradeButton, label)) in armyUpgrades.enumerated() {
            upgradeButton.position = positionForArmyUpgradeButton(index: index, count: armyUpgrades.count, state: .Enter)
            timeline.after(time: PurchaseAnimationDuration / 2) {
                upgradeButton.moveTo(self.positionForArmyUpgradeButton(index: index, count: armyUpgrades.count, state: .Default),
                    duration: PurchaseAnimationDuration / 2)
            }
            upgradeArmyLayer << upgradeButton
        }

        let back = generateBackButton()
        back.onTapped {
            armyCenterNode.moveTo(originalArmyButton.position, duration: PurchaseAnimationDuration / 2)
            self.timeline.after(time: PurchaseAnimationDuration) {
                armyCenterNode.removeFromParent()
                originalArmyButton.alpha = 1
                armySprite.move(toParent: originalArmyButton)
                armySprite.position = .zero
            }
            self.closeArmyLayer()
        }
        upgradeArmyLayer << back
    }

    func closeArmyLayer() {
        self << mainLayer
        defaultNode = nil
        upgradeArmyLayer.interactive = false

        upgradeArmyLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.upgradeArmyLayer.removeAllChildren()

            self.mainLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2).onFaded {
                self.mainLayer.interactive = true
            }
        }
    }

}
