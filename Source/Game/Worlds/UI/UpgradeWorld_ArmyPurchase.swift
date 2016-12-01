////
///  UpgradeWorld_ArmyPurchase.swift
//

extension UpgradeWorld {

    func showArmyPurchase() {
        title.text = "RECRUIT"
        mainLayer.interactive = false
        mainLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.purchaseArmyLayer.interactive = true
            self.purchaseArmyLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2)
            self.mainLayer.removeFromParent(reset: false)
        }

        let backButton = generateBackButton()
        backButton.onTapped {
            self.closePurchaseLayer()
        }
        purchaseArmyLayer << backButton
    }

    func closePurchaseLayer() {
        self << mainLayer
        self.willShowMain()
        defaultNode = nil
        purchaseArmyLayer.interactive = false

        purchaseArmyLayer.fadeTo(0, duration: PurchaseAnimationDuration / 2).onFaded {
            self.purchaseArmyLayer.removeAllChildren()

            self.mainLayer.fadeTo(1, duration: PurchaseAnimationDuration / 2).onFaded {
                self.mainLayer.interactive = true
            }
        }
    }

}
