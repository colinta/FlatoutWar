////
///  UpgradeWorld.swift
//

class UpgradeWorld: UIWorld {
    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: LevelConfig { return nextWorld.config }

    var powerupButtons: [Button] = []
    let mainLayer = Node()
    let powerupLayer = Node()
    let upgradeTowerLayer = Node()
    let purchaseTowerLayer = Node()

    var playerNode: BasePlayerNode!
    var armyNodes: [Node] = []
    var armyNodesMainPosition: [Node: CGPoint] = [:]
    var armyNodesUpgradePosition: [Node: CGPoint] = [:]

    var gainedResources: TextNode!
    var gainedExperience: TextNode!

    override func worldShook() {
        Artist.saveCache()
    }

    func backButton() -> Button {
        let back = Button()
        back.alignment = .Left
        back.position = CGPoint(x: -size.width / 2 + 15, y: size.height / 2 - 30)
        back.text = "< BACK"
        return back
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

        self << mainLayer

        do {
            powerupLayer.alpha = 0
            self << powerupLayer
        }

        do {
            upgradeTowerLayer << backButton()
            upgradeTowerLayer.alpha = 0
            self << upgradeTowerLayer
        }

        do {
            purchaseTowerLayer << backButton()
            purchaseTowerLayer.alpha = 0
            self << purchaseTowerLayer
        }

        let title = TextNode()
        title.font = .Big
        title.text = "ARMORY"
        title.position = CGPoint(y: size.height / 2 - 22)
        self << title

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

            armyNodesMainPosition[armyNode] = position

            angle += deltaAngle
        }

        let position = CGPoint(r: buttonRadius, a: angle)
        purchase.position = position

        let x: CGFloat = -size.width / 2 + 40
        var y: CGFloat = size.height / 2 - 40
        let dy: CGFloat = 80
        for powerup in levelConfig.activatedPowerups {
            let icon = powerup.icon()
            let powerupButton = Button(at: CGPoint(x, y))
            powerupButton << icon
            powerupButton.style = .Circle
            mainLayer << powerupButton

            powerupButton.onTapped {
                powerupButton.enabled = false
                self.showPowerupUpgrade(powerup, powerupButton: powerupButton)
            }

            powerupButtons << powerupButton
            y -= dy
        }
    }

    func showPowerupUpgrade(powerup: Powerup, powerupButton: Button) {
        let startPosition = powerupButton.position

        let powerupTarget = Node()
        powerupTarget << SKSpriteNode(id: .ColorCircle(size: CGSize(60), color: 0xFFFFFF))
        powerupTarget << powerup.icon()
        powerupTarget.moveTo(.zero, start: startPosition, duration: 1)
        self << powerupTarget

        mainLayer.fadeTo(0, duration: 0.5).onFaded {
            self.powerupLayer.interactive = true
            self.powerupLayer.fadeTo(1, duration: 0.5)
        }

        let back = backButton()
        back.onTapped {
            powerupTarget.moveTo(startPosition, duration: 1).onArrived {
                powerupButton.enabled = true
                powerupTarget.removeFromParent()
            }
            self.closePowerupLayer()
        }
        powerupLayer << back

        let purchaseablePowerups = [powerup] + levelConfig.purchaseablePowerups
        var angle: CGFloat = TAU_4
        let buttonRadius: CGFloat = 90
        let deltaAngle = TAU / CGFloat(purchaseablePowerups.count)
        for purchaseablePowerup in purchaseablePowerups {
            let icon = purchaseablePowerup.icon()
            let powerupButton = Button(at: CGPoint(r: buttonRadius, a: angle))
            powerupButton << icon
            powerupButton.style = .Circle
            powerupLayer << powerupButton

            powerupButton.onTapped {
                self.powerupDemo(purchaseablePowerup)
            }

            powerupButtons << powerupButton
            angle += deltaAngle
        }
    }

    func powerupDemo(powerup: Powerup) {
        switch powerup {
        case is BomberPowerup: powerupDemo_BomberPowerup()
        case is CoffeePowerup: powerupDemo_CoffeePowerup()
        case is DecoyPowerup: powerupDemo_DecoyPowerup()
        case is GrenadePowerup: powerupDemo_GrenadePowerup()
        case is HourglassPowerup: powerupDemo_HourglassPowerup()
        case is LaserPowerup: powerupDemo_LaserPowerup()
        case is MinesPowerup: powerupDemo_MinesPowerup()
        case is NetPowerup: powerupDemo_NetPowerup()
        case is PulsePowerup: powerupDemo_PulsePowerup()
        case is ShieldPowerup: powerupDemo_ShieldPowerup()
        case is SoldiersPowerup: powerupDemo_SoldiersPowerup()
        default: break
        }
    }

    func closePowerupLayer() {
        powerupLayer.interactive = false
        powerupLayer.fadeTo(0, duration: 0.5).onFaded {
            self.powerupLayer.removeAllChildren()
            self.mainLayer.fadeTo(1, duration: 0.5)
        }
    }

}
