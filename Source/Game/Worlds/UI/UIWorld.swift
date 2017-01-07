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
    func populateCurrencies(config: GameConfigSummary) -> TextNode {
        let position = CGPoint(
            size.width / 2 - 10,
            -size.height / 2 + 20)

        let experienceInfo = SKNode()
        experienceInfo.position = position
        uiLayer << experienceInfo

        let experienceSquare = SKSpriteNode(id: .ExperienceIcon)
        experienceInfo << experienceSquare

        let gainedExperience = TextNode()
        gainedExperience.text = "\(config.availableExperience)"
        gainedExperience.position = CGPoint(x: -10)
        gainedExperience.alignment = .right
        experienceInfo << gainedExperience

        return gainedExperience
    }
}
