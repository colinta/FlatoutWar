////
///  UpgradeWorld.swift
//

let PurchaseAnimationDuration: CGFloat = 1
let ButtonAnimationDuration: CGFloat = 0.5
let LayerAnimationDuration: CGFloat = 0.3


class UpgradeWorld: UIWorld {

    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: LevelConfig { return nextWorld.config }

    var playerNode: BasePlayerNode!
    var armyNodes: [Node] = []
    let mainLayer = Node()

    let powerupLayer = Node()
    var prevSelectedPowerupLayer: Node?

    let upgradeArmyLayer = Node()
    let purchaseTowerLayer = Node()

    var gainedResources: TextNode!
    var printedResources: Int = 0
    var gainedExperience: TextNode!
    var printedExperience: Int = 0

    func saveAndExit() {
        levelConfig.storedPlayers = [playerNode] + armyNodes.map { node in
            node.position = convertPosition(node)
            return node
        }
        director?.presentWorld(nextWorld)
    }

    override func update(dt: CGFloat) {
        super.update(dt)
        if config.availableResources < printedResources {
            printedResources -= 1
            gainedResources.text = "\(printedResources)"
        }
        if config.availableExperience < printedExperience {
            printedExperience -= 1
            gainedResources.text = "\(printedExperience)"
        }
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
        done.alignment = .Right
        done.position = CGPoint(x: size.width / 2 - 15, y: size.height / 2 - 30)
        done.text = "DONE >"
        done.onTapped {
            self.fadeTo(0, duration: 0.5).onFaded(self.saveAndExit)
        }
        return done
    }

    func generatePowerupButton(powerup: Powerup, includeCount: Bool = true, includeCost: Bool = false) -> PowerupUpgradeButton {
        return PowerupUpgradeButton(powerup: powerup, includeCount: includeCount, includeCost: includeCost)
    }

    override func populateWorld() {
        super.populateWorld()

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
            upgradeArmyLayer.alpha = 0
            self << upgradeArmyLayer
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
        self.printedResources = config.availableResources
        self.gainedResources = gainedResources
        self.printedExperience = config.availableExperience
        self.gainedExperience = gainedExperience

        showMainScreen()

        fadeTo(1, start: 0, duration: 0.5)
    }

    func showMainScreen() {
        playerNode.disableTouchForUI()
        let playerNodeButton = ArmyUpgradeButton(node: playerNode)
        mainLayer << playerNodeButton

        let purchaseTower = Button()
        let armyButtons = armyNodes.map { ArmyUpgradeButton(node: $0) }
        positionArmyButtons(playerNodeButton, armyButtons: armyButtons, purchaseTower: purchaseTower)

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

}
