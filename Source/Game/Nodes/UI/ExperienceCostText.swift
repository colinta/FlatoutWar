////
///  ExperienceCostText.swift
//

class ExperienceCostText: Node {
    let icon = SKSpriteNode(id: .ExperienceIcon)
    let costNode = TextNode()
    var cost: Int = 0 {
        didSet {
            costNode.text = "\(cost)"
            size = CGSize(icon.frame.width + costNode.size.width, costNode.size.height)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init() {
        super.init()
        self << icon

        costNode.text = ""
        costNode.position = CGPoint(x: 10)
        costNode.alignment = .left
        self << costNode
    }

}
