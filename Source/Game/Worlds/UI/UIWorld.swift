////
///  UIWorld.swift
//

class UIWorld: World {
    let uiLayer = Node()

    override func populateWorld() {
        super.populateWorld()

        self << uiLayer
    }

    @discardableResult
    func populateCurrencies(config: UpgradeConfigSummary) -> (TextNode, TextNode) {
        let resourceX = size.width / 2 - 10
        let resourceY = -size.height / 2 + 20
        let dy: CGFloat = 25

        let experienceInfo = SKNode()
        experienceInfo.position = CGPoint(x: resourceX, y: resourceY)
        uiLayer << experienceInfo

        let experienceSquare = SKSpriteNode(id: .ExperienceIcon)
        experienceInfo << experienceSquare

        let gainedExperience = TextNode()
        gainedExperience.text = "\(config.availableExperience)"
        gainedExperience.position = CGPoint(x: -10)
        gainedExperience.alignment = .right
        experienceInfo << gainedExperience

        let resourceInfo = SKNode()
        resourceInfo.position = CGPoint(x: resourceX, y: resourceY + dy)
        uiLayer << resourceInfo

        let resourceSquare = SKSpriteNode(id: .ResourceIcon)
        resourceInfo << resourceSquare

        let gainedResources = TextNode()
        gainedResources.text = "\(config.availableResources)"
        gainedResources.position = CGPoint(x: -10)
        gainedResources.alignment = .right
        resourceInfo << gainedResources

        return (gainedResources, gainedExperience)
    }
}
