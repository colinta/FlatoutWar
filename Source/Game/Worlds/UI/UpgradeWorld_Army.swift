////
///  UpgradeWorld_Army.swift
//

extension UpgradeWorld {

    func positionArmyButtons(playerNodeButton: ArmyUpgradeButton, armyButtons: [ArmyUpgradeButton], purchaseTower: Button) {
        playerNodeButton.onTapped { self.showArmyUpgrade(armyButton: playerNodeButton) }

        var angle = 7 * TAU_12
        let buttonRadius: CGFloat = 80
        let deltaAngle = TAU / CGFloat(armyButtons.count + 1)
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

    func showArmyUpgrade(armyButton armyButton: ArmyUpgradeButton) {
        guard let
            armyUpgrades = (armyButton.node as? UpgradeableNodes)?.availableUpgrades(world: self)
        else { return }

        mainLayer.interactive = false
        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.upgradeArmyLayer.interactive = true
            self.upgradeArmyLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let back = generateBackButton()
        back.onTapped(closeArmyLayer)
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
