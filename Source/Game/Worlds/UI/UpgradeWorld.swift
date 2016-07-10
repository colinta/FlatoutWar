////
///  UpgradeWorld.swift
//

class UpgradeWorld: World {
    var nextWorld: Level!
    let config = UpgradeConfigSummary()
    var levelConfig: BaseConfig { return nextWorld.config }

    let mainLayer = Node()
    let powerupLayer = Node()
    let upgradeTowerLayer = Node()
    let purchaseTowerLayer = Node()

    var playerNode: BasePlayerNode!
    var armyNodes: [Node] = []
    var armyNodesMainPosition: [Node: CGPoint] = [:]
    var armyNodesUpgradePosition: [Node: CGPoint] = [:]

    let gainedResources = TextNode()
    let gainedExperience = TextNode()

    override func worldShook() {
        Artist.saveCache()
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
        self << powerupLayer
        self << upgradeTowerLayer
        self << purchaseTowerLayer

        showUI()
        showMainScreen()
        // showPowerupUpgrade()

        fadeTo(1, start: 0, duration: 0.5)
    }

    func showUI() {
        let title = TextNode()
        title.font = .Big
        title.text = "ARMORY"
        title.position = CGPoint(y: size.height / 2 - 22)
        self << title

        let resourceY = -size.height / 2 + 20

        let resourceSquare = SKSpriteNode(id: .Box(color: ResourceBlue))
        resourceSquare.position = CGPoint(x: -10, y: resourceY)
        self << resourceSquare

        gainedResources.text = "\(config.totalGainedExperience)"
        gainedResources.position = CGPoint(x: -20, y: resourceY)
        gainedResources.alignment = .Right
        self << gainedResources

        let experienceSquare = SKSpriteNode(id: .Box(color: EnemySoldierGreen))
        experienceSquare.position = CGPoint(x: 10, y: resourceY)
        self << experienceSquare

        gainedExperience.text = "\(config.totalGainedResources)"
        gainedExperience.position = CGPoint(x: 20, y: resourceY)
        gainedExperience.alignment = .Left
        self << gainedExperience
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
        let radius: CGFloat = 80
        let deltaAngle = TAU / CGFloat(armyNodes.count + 1)
        for armyNode in armyNodes {
            let position = CGPoint(r: radius, a: angle)

            armyNode.touchableComponent?.enabled = false

            let armyNodeButton = Button()
            armyNodeButton.position = position
            armyNodeButton.style = .Circle
            armyNodeButton << armyNode
            mainLayer << armyNodeButton

            armyNodesMainPosition[armyNode] = position

            angle += deltaAngle
        }

        let position = CGPoint(r: radius, a: angle)
        purchase.position = position

        let powerups = levelConfig.availablePowerups
        let x: CGFloat = -size.width / 2 + 40
        var y: CGFloat = size.height / 2 - 40
        let dy: CGFloat = 80
        for powerup in powerups {
            let icon = powerup.icon()
            let powerupButton = Button(at: CGPoint(x, y))
            powerupButton << icon
            powerupButton.style = .Circle
            mainLayer << powerupButton

            y -= dy
        }
    }

    func showPowerupUpgrade(powerup: Powerup, button: Button) {
    }

}
