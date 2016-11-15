////
///  PowerupUpgradeButton.swift
//

class PowerupUpgradeButton: Button {
    var icon: SKSpriteNode?
    var resourceCostNode: ResourceCostText?
    var powerupCountNode: TextNode?

    var powerup: Powerup {
        didSet {
            updateUI()
        }
    }

    required init(powerup: Powerup, includeCount: Bool, includeCost: Bool) {
        self.powerup = powerup
        icon = powerup.icon()
        super.init()

        updateUI(includeCount: includeCount, includeCost: includeCost)
        style = .Circle
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(includeCount initCounts: Bool? = nil, includeCost initResource: Bool? = nil) {
        if let prevIcon = self.icon {
            prevIcon.removeFromParent()
        }

        let icon = powerup.icon()
        self.icon = icon

        var nodes: [SKNode] = [icon]
        var includeCount = initCounts ?? false
        var powerupCountColor: Int?
        if let prevPowerupCountNode = powerupCountNode {
            powerupCountColor = prevPowerupCountNode.color
            prevPowerupCountNode.removeFromParent()
            includeCount = true
        }

        if includeCount {
            let powerupCountNode = powerup.powerupCountNode()
            if let color = powerupCountColor {
                powerupCountNode.color = color
            }
            self.powerupCountNode = powerupCountNode
            nodes << powerupCountNode
        }

        var includeCost = initResource ?? false
        if let prevResourceCostNode = resourceCostNode {
            prevResourceCostNode.removeFromParent()
            includeCost = true
        }

        if includeCost {
            let resourceCostNode = powerup.resourceCostNode()
            resourceCostNode.position = CGPoint(x: 50, y: -15)
            self.resourceCostNode = resourceCostNode
            nodes << resourceCostNode
        }

        if includeCost {
            let label = TextNode(at: CGPoint(x: 50, y: 15))
            label.text = powerup.name
            label.alignment = .left
            nodes << label
        }

        let dx: CGFloat = (includeCount || includeCost) ? 6 : 0
        for node in nodes {
            node.position.x -= dx
            self << node
        }
    }

}
