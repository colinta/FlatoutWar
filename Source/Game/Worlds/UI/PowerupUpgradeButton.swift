////
///  PowerupUpgradeButton.swift
//

class PowerupUpgradeButton: Button {
    var icon: SKSpriteNode?
    var resourceCostNode: Node?
    var powerupCountNode: Node?

    let originalPowerup: Powerup
    var currentPowerup: Powerup {
        didSet {
            updateUI(currentPowerup)
        }
    }

    required init(powerup: Powerup, includeCount: Bool, includeCost: Bool) {
        originalPowerup = powerup
        currentPowerup = powerup
        icon = powerup.icon()
        super.init()

        updateUI(powerup, includeCount: includeCount, includeCost: includeCost)
        style = .Circle
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func restoreOriginal() {
        currentPowerup = originalPowerup
    }

    func updateUI(powerup: Powerup, includeCount initCounts: Bool? = nil, includeCost initResource: Bool? = nil) {
        if let prevIcon = self.icon {
            prevIcon.removeFromParent()
        }

        let icon = currentPowerup.icon()
        self.icon = icon

        var nodes: [SKNode] = [icon]

        var includeCount = initCounts
        if let prevPowerupCountNode = powerupCountNode {
            prevPowerupCountNode.removeFromParent()
            includeCount = true
        }
        if includeCount == true {
            let powerupCountNode = powerup.powerupCountNode()
            self.powerupCountNode = powerupCountNode
            nodes << powerupCountNode
        }

        var includeCost = initResource
        if let prevResourceCostNode = resourceCostNode {
            prevResourceCostNode.removeFromParent()
            includeCost = true
        }
        if includeCost == true {
            let resourceCostNode = powerup.resourceCostNode()
            self.resourceCostNode = resourceCostNode
            nodes << resourceCostNode
        }

        for node in nodes {
            node.position.x -= 4
            self << node
        }
    }

}
