////
///  UpgradeWorld.swift
//

let PurchaseAnimationDuration: CGFloat = 1
let ButtonAnimationDuration: CGFloat = 0.5
let LayerAnimationDuration: CGFloat = 0.3


class UpgradeWorld: UIWorld {
    let title = TextNode()

    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: LevelConfig { return nextWorld.config }

    var playerNode: BasePlayerNode!
    var armyNodes: [Node] = []
    let mainLayer = Node()

    let powerupLayer = Node()
    var prevSelectedPowerupLayer: Node?

    let upgradeArmyLayer = Node()
    let purchaseArmyLayer = Node()

    var gainedExperience: TextNode!
    var printedExperience: Int = 0

    func saveAndExit() {
        levelConfig.didUpgrade = true
        director?.presentWorld(nextWorld)
    }

    override func update(_ dt: CGFloat) {
        super.update(dt)
        if config.availableExperience < printedExperience {
            let delta = Int(pow(10, max(1, floor(log(Float(printedExperience - config.availableExperience)) / log(10)) - 1)))
            printedExperience = max(config.availableExperience, printedExperience - delta)
            gainedExperience.text = "\(printedExperience)"
        }
    }

    func generateBackButton() -> Button {
        let back = Button()
        back.alignment = .left
        back.position = CGPoint(x: -size.width / 2 + 15, y: size.height / 2 - 30)
        back.text = "< BACK"
        return back
    }

    func generateDoneButton() -> Button {
        let done = Button()
        done.alignment = .right
        done.position = CGPoint(x: size.width / 2 - 15, y: size.height / 2 - 30)
        done.text = "DONE >"
        done.onTapped {
            self.fadeTo(0, duration: 0.5).onFaded(self.saveAndExit)
        }
        return done
    }

    func generatePowerupButton(_ powerup: Powerup, includeCount: Bool = true, includeCost: Bool = false) -> PowerupUpgradeButton {
        return PowerupUpgradeButton(powerup: powerup, includeCount: includeCount, includeCost: includeCost)
    }

    func willShowMain() {
        title.text = "ARMORY"
    }

    override func populateWorld() {
        super.populateWorld()

        // for node in levelConfig.storedPlayers {
        //     if let node = node as? BasePlayerNode {
        //         playerNode = node
        //     }
        //     else {
        //         armyNodes << node
        //     }
        // }

        mainLayer << generateDoneButton()
        self << mainLayer

        do {
            powerupLayer.alpha = 0
            self << powerupLayer
        }

        do {
            upgradeArmyLayer.alpha = 0
            self << upgradeArmyLayer
        }

        do {
            purchaseArmyLayer.alpha = 0
            self << purchaseArmyLayer
        }

        title.font = .Big
        title.text = "ARMORY"
        title.position = CGPoint(y: size.height / 2 - 22)
        uiLayer << title

        let gainedExperience = populateCurrencies(config: config)
        self.printedExperience = config.availableExperience
        self.gainedExperience = gainedExperience

        showMainScreen()

        fadeTo(1, start: 0, duration: 0.5)
    }

    func showMainScreen() {
        playerNode.disableTouchForUI()
        let playerNodeButton = ArmyUpgradeButton(node: playerNode, info: nil)
        mainLayer << playerNodeButton

        let purchaseArmy = Button()
        let armyButtons = armyNodes.map { ArmyUpgradeButton(node: $0, info: nil) }
        positionArmyButtons(playerNodeButton: playerNodeButton, armyButtons: armyButtons, purchaseArmy: purchaseArmy)

        let x: CGFloat = -size.width / 2 + 40
        let dy: CGFloat = 80
        var y: CGFloat = size.height / 2 - dy
        for powerup in levelConfig.activatedPowerups {
            let powerupButton = generatePowerupButton(powerup)
            powerupButton.position = CGPoint(x, y)
            mainLayer << powerupButton
            powerupButton.onTapped { self.showPowerupUpgrade(mainButton: powerupButton) }

            y -= dy
        }
    }

    func positionArmyButtons(playerNodeButton: ArmyUpgradeButton, armyButtons: [ArmyUpgradeButton], purchaseArmy: Button) {
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
        purchaseArmy.position = position
        purchaseArmy.style = .Circle
        purchaseArmy.text = "+"
        purchaseArmy.onTapped(showArmyPurchase)
        mainLayer << purchaseArmy
    }

    enum ButtonState {
        case Inactive
        case Active
        case Selecting
    }
    func positionForUpgradeButton(
        index: Int,
        state: ButtonState
        ) -> CGPoint
    {
        let center = CGPoint(0, 80)
        let dy: CGFloat = -80
        let dx: CGFloat = 160

        switch state {
        case .Active:
            return center + CGPoint(y: dy * CGFloat(index))
        case .Inactive:
            return center + CGPoint(dx, dy * CGFloat(index))
        case .Selecting:
            return CGPoint(y: 60)
        }
    }

}
