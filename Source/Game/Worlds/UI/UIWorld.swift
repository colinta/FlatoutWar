////
///  UIWorld.swift
//

class UIWorld: World {

    func populateCurrencies(config: UpgradeConfigSummary) -> (TextNode, TextNode) {
        let resourceY = -size.height / 2 + 20

        let experienceInfo = SKNode()
        experienceInfo.position = CGPoint(x: -10, y: resourceY)
        self.ui << experienceInfo

        let experienceSquare = SKSpriteNode(id: .Box(color: EnemySoldierGreen))
        experienceInfo << experienceSquare

        let gainedExperience = TextNode()
        gainedExperience.text = "\(config.totalGainedExperience)"
        gainedExperience.position = CGPoint(x: -10)
        gainedExperience.alignment = .Right
        experienceInfo << gainedExperience

        let resourceInfo = SKNode()
        resourceInfo.position = CGPoint(x: 10, y: resourceY)
        self.ui << resourceInfo

        let resourceSquare = SKSpriteNode(id: .Box(color: ResourceBlue))
        resourceInfo << resourceSquare

        let gainedResources = TextNode()
        gainedResources.text = "\(config.totalGainedResources)"
        gainedResources.position = CGPoint(x: 10)
        gainedResources.alignment = .Left
        resourceInfo << gainedResources

        return (gainedResources, gainedExperience)
    }
}
