////
///  ArmyUpgradeButton.swift
//

class ArmyUpgradeButton: Button {
    let node: Node
    let label = TextNode()
    let costExperience = ExperienceCostText()
    let costResources = ResourceCostText()
    var upgradeEnabled = true {
        didSet {
            if !upgradeEnabled {
                enabled = false
            }
        }
    }
    override var enabled: Bool {
        didSet {
            if enabled && !upgradeEnabled {
                enabled = false
            }
        }
    }

    static func disableNode(_ node: Node) {
        node.healthComponent?.enabled = false
        node.firingComponent?.enabled = false
        node.playerComponent?.targetable = false
        node.touchableComponent?.enabled = false
    }

    required init(node: Node, info: UpgradeInfo?) {
        self.node = node
        super.init()
        ArmyUpgradeButton.disableNode(node)
        style = .Circle
        node.position = .zero
        node.firingComponent?.enabled = false
        node.playerComponent?.targetable = false
        node.touchableComponent?.enabled = false
        self << node

        if let info = info {
            let textX: CGFloat = 40
            let textY: CGFloat = 15
            label.position = CGPoint(x: textX, y: textY)
            label.text = info.title
            label.alignment = .left
            self << label

            var costX: CGFloat = textX + 10

            costExperience.cost = info.cost.experience
            self << costExperience

            costResources.cost = info.cost.resources
            self << costResources

            costResources.position = CGPoint(costX, -textY)
            costX += costResources.size.width + 10
            costExperience.position = CGPoint(costX, -textY)
        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
