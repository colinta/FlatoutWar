////
///  PowerupUpgradeButton.swift
//

class PowerupUpgradeButton: Button {
    var icon: SKSpriteNode?
    var resourceCostNode: TextNode?
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
        var includeCount = initCounts
        var powerupCountColor: Int?
        if let prevPowerupCountNode = powerupCountNode {
            powerupCountColor = prevPowerupCountNode.color
            prevPowerupCountNode.removeFromParent()
            includeCount = true
        }

        if includeCount == true {
            let powerupCountNode = powerup.powerupCountNode()
            if let color = powerupCountColor {
                powerupCountNode.color = color
            }
            self.powerupCountNode = powerupCountNode
            nodes << powerupCountNode
        }

        var includeCost = initResource
        var powerupCostColor: Int?
        if let prevResourceCostNode = resourceCostNode {
            powerupCostColor = prevResourceCostNode.color
            prevResourceCostNode.removeFromParent()
            includeCost = true
        }

        if includeCost == true {
            let resourceCostNode = powerup.resourceCostNode()
            if let color = powerupCostColor {
                resourceCostNode.color = color
            }
            self.resourceCostNode = resourceCostNode
            nodes << resourceCostNode
        }

        let dx: CGFloat = (includeCount == true || includeCost == true) ? 6 : 0
        for node in nodes {
            node.position.x -= dx
            self << node
        }
    }

}
