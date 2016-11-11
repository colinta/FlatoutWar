////
///  WorldSelectWorld.swift
//


class WorldSelectWorld: UIWorld {
    var worldLocations: [LevelId: CGPoint]!
    var worldSelect: Node!
    var beginAt: LevelId = .Select

    enum LevelId {
        case PanIn
        case Select
        case Tutorial
        case Base
    }

    convenience init(beginAt: LevelId) {
        self.init()
        self.beginAt = beginAt
    }

    override func populateWorld() {
        worldLocations = [
            .Tutorial: CGPoint(-200, 0),
            .Base: CGPoint(-200, 100),
        ]

        if beginAt == .PanIn {
            let startLeft = -size.width
            self.moveCamera(from: CGPoint(x: startLeft),
                to: CGPoint(x: 0),
                duration: 3)
        }

        worldSelect = Node()
        self << worldSelect

        worldSelect << Line(
            from: CGPoint(x: -350),
            to: CGPoint(x: -225)
        )
        worldSelect << Line(
            from: CGPoint(x: -200, y: 25),
            to: CGPoint(x: -200, y: 75)
        )

        let summaryConfig = UpgradeConfigSummary()
        let tutorialConfig = TutorialConfigSummary()
        let baseConfig = BaseConfigSummary()

        populateCurrencies(config: summaryConfig)

        do {
            let button = Button(at: worldLocations[.Tutorial]!)
            button.background = BackgroundColor
            button.style = .SquareSized(50)
            button.font = .Big
            button.onTapped {
                self.interactionEnabled = false
                self.transitionToTutorial()
            }
            button.text = "0"
            worldSelect << button

            let box = LevelCompleteBox()
            box.size = button.size
            box.complete = tutorialConfig.percentCompleted
            button << box
        }

        do {
            let button = Button(at: worldLocations[.Base]!)
            button.background = BackgroundColor
            button.style = .SquareSized(50)
            button.font = .Big
            button.enabled = tutorialConfig.worldCompleted
            button.onTapped {
                self.interactionEnabled = false
                self.transitionToBase()
            }
            button.text = "1"
            worldSelect << button

            if button.enabled {
                let box = LevelCompleteBox()
                box.size = button.size
                box.complete = baseConfig.percentCompleted
                button << box
            }
        }

        switch beginAt {
        case .Tutorial:
            transitionToTutorial(animate: false)
        case .Base:
            transitionToBase(animate: false)
        default: break
        }
    }

    func transitionToLevel(at levelLocation: CGPoint, animate: Bool) -> Node {
        let levelSelect = Node()
        levelSelect.position = levelLocation
        self << levelSelect

        let animationDurationIn: CGFloat = 0.8
        let animationDurationOut: CGFloat = 0.5
        if animate {
            timeline.after(time: animationDurationIn) { self.interactionEnabled = true }
            worldSelect.fadeTo(0, duration: animationDurationIn)
            worldSelect.scaleTo(1.5, duration: animationDurationIn)
            moveCamera(to: levelLocation, duration: animationDurationIn)
            levelSelect.fadeTo(1, start: 0, duration: animationDurationIn)
            levelSelect.scaleTo(1, start: 0.5, duration: animationDurationIn)
        }
        else {
            interactionEnabled = true
            worldSelect.alpha = 0
            worldSelect.setScale(1.5)
            moveCamera(from: levelLocation)
            levelSelect.alpha = 1
            levelSelect.setScale(1)
        }

        let backButton = Button(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.font = .Big
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped {
            self.interactionEnabled = false
            self.timeline.after(time: 1) { self.interactionEnabled = true }
            levelSelect.fadeTo(0, duration: animationDurationOut, removeNode: true)
            levelSelect.scaleTo(0.5, duration: animationDurationOut)
            self.worldSelect.fadeTo(1, duration: animationDurationOut)
            self.worldSelect.scaleTo(1, duration: animationDurationOut)
            self.moveCamera(to: .zero, duration: animationDurationOut)
        }
        levelSelect << backButton

        return levelSelect
    }

// MARK: TUTORIAL
    func transitionToTutorial(animate: Bool = true) {
        let levelSelect = transitionToLevel(at: worldLocations[.Tutorial]!, animate: animate)

        let tutorialTitle = TextNode(at: CGPoint(y: 130))
        tutorialTitle.font = .Big
        tutorialTitle.text = "TRAINING"
        levelSelect << tutorialTitle

        let tutorialButton = Button(at: CGPoint(x: -200, y: 20))
        tutorialButton.font = .Big
        tutorialButton.text = "?"
        tutorialButton.size = CGSize(width: 15, height: 15)
        tutorialButton.onTapped {
            self.director?.presentWorld(TutorialSelectWorld())
        }

        levelSelect << tutorialButton

        // wandering enemies
        do {
            let center = CGPoint(x: 200, y: 0)
            let delta: CGFloat = 20
            let enemyPositions = [
                center + CGPoint(x: -delta, y: -delta),
                center + CGPoint(x: 0, y: -delta),
                center + CGPoint(x: delta, y: -delta),
                center + CGPoint(x: -delta, y: 0),
                center + CGPoint(x: 0, y: 0),
                center + CGPoint(x: delta, y: 0),
                center + CGPoint(x: -delta, y: delta),
                center + CGPoint(x: 0, y: delta),
                center + CGPoint(x: delta, y: delta),
            ]
            for pos in enemyPositions {
                let enemyNode = EnemySoldierNode(at: pos)
                let wanderingComponent = WanderingComponent()
                wanderingComponent.centeredAround = pos
                enemyNode.addComponent(wanderingComponent)
                levelSelect << enemyNode
            }
        }

        var prevLevel: Level?
        var prevPosition: CGPoint?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, Level)] = [
            (0, 0, TutorialLevel1()),
            (1, 0, TutorialLevel2()),
            (1, 1, TutorialLevel3()),
            (1, 2, TutorialLevel4()),
            (2, 2, TutorialLevel5()),
            (2, 1, TutorialLevel6()),
        ]
        let center = CGPoint(y: -20)
        let dx: CGFloat = 65
        let dy: CGFloat = 80
        for (xOffset, yOffset, level) in levels {
            let x: CGFloat = (xOffset - 1) * dx
            let y: CGFloat = (yOffset - 1) * dy
            let position = center + CGPoint(x, y)

            let button = generateButton(
                at: position,
                level: level,
                prevLevel: prevLevel)
            button.text = "\(levelIndex + 1)"
            levelSelect << button

            levelSelect << levelInfo(at: position, level: level)

            if let prevPosition = prevPosition {
                levelSelect << lineBetween(position, and: prevPosition, enabled: button.enabled)
            }

            prevLevel = level
            prevPosition = position
            levelIndex += 1
        }
    }

// MARK: BASE
    func transitionToBase(animate: Bool = true) {
        let levelSelect = transitionToLevel(at: worldLocations[.Base]!, animate: animate)

        let tutorialTitle = TextNode(at: CGPoint(y: 130))
        tutorialTitle.font = .Big
        tutorialTitle.text = "BASE"
        levelSelect << tutorialTitle

        // wandering enemies
        do {
            let center = CGPoint(x: 200, y: 0)
            let delta: CGFloat = 20
            let enemyPositions = [
                center + CGPoint(x: -delta, y: -delta),
                center + CGPoint(x: 0, y: -delta),
                center + CGPoint(x: delta, y: -delta),
                center + CGPoint(x: -delta, y: 0),
                center + CGPoint(x: 0, y: 0),
                center + CGPoint(x: delta, y: 0),
                center + CGPoint(x: -delta, y: delta),
                center + CGPoint(x: 0, y: delta),
                center + CGPoint(x: delta, y: delta),
            ]
            for pos in enemyPositions {
                let enemyNode = EnemySoldierNode(at: pos)
                let wanderingComponent = WanderingComponent()
                wanderingComponent.centeredAround = pos
                enemyNode.addComponent(wanderingComponent)
                levelSelect << enemyNode
            }
        }

        var prevLevel: Level?
        var prevPosition: CGPoint?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, Level)] = [
            (0, 0, BaseLevel1()),
            (1, 0, BaseLevel2()),
            (2, 1, BaseLevel3()),
            (2, 2, BaseLevel4()),
            (1, 2, BaseLevel5()),
        ]
        let center = CGPoint(y: -20)
        let dx: CGFloat = 65
        let dy: CGFloat = 80
        for (xOffset, yOffset, level) in levels {
            let x: CGFloat = (xOffset - 1) * dx
            let y: CGFloat = (yOffset - 1) * dy
            let position = center + CGPoint(x, y)

            let upgrade = UpgradeWorld()
            upgrade.nextWorld = level
            let button = generateButton(
                at: position,
                level: level, prevLevel: prevLevel,
                presentWorld: upgrade)
            button.text = "\(levelIndex + 1)"
            levelSelect << button

            levelSelect << levelInfo(at: position, level: level)

            if let prevPosition = prevPosition {
                levelSelect << lineBetween(position, and: prevPosition, enabled: button.enabled)
            }

            prevLevel = level
            prevPosition = position
            levelIndex += 1
        }
    }

}

extension WorldSelectWorld {
    func generateButton(at center: CGPoint, level: Level, prevLevel: Level?, presentWorld: World? = nil) -> Button {
        let button = Button(at: center)
        let completed = prevLevel?.config.levelCompleted ?? true
        button.background = BackgroundColor
        button.enabled = completed
        button.size = CGSize(50)
        button.style = .Square
        button.font = .Big
        button.onTapped {
            self.interactionEnabled = false
            self.fadeTo(0, duration: 0.5).onFaded {
                level.shouldReturnToLevelSelect = true
                self.director?.presentWorld(presentWorld ?? level.tutorialOrLevel())
            }
        }

        if completed {
            let box = LevelCompleteBox()
            box.size = button.size
            box.complete = level.config.percentCompleted
            button << box
        }
        return button
    }

    func levelInfo(at position: CGPoint, level: Level) -> SKNode {
        let info = SKNode()
        info.position = position + CGPoint(x: -10, y: -40)
        info.setScale(0.75)

        let experienceSquare = SKSpriteNode(id: .ExperienceIcon)
        experienceSquare.position = CGPoint(y: 8)
        info << experienceSquare
        let experienceText = TextNode()
        experienceText.position = CGPoint(x: 8, y: 8)
        experienceText.setScale(0.5)
        experienceText.alignment = .left
        experienceText.text = "\(level.config.gainedExperience)"
        info << experienceText

        if level.config.expectedResources > 0 {
            let resourceSquare = SKSpriteNode(id: .ResourceIcon)
            resourceSquare.position = CGPoint(y: -8)
            info << resourceSquare
            let resourceText = TextNode()
            resourceText.position = CGPoint(x: 8, y: -8)
            resourceText.setScale(0.5)
            resourceText.alignment = .left
            resourceText.text = "\(level.config.gainedResources)"
            info << resourceText
        }

        return info
    }

    func lineBetween(_ position: CGPoint, and prevPosition: CGPoint, enabled: Bool) -> SKNode {
        let dx: CGFloat = 25
        let dy: CGFloat = 25
        var p0 = prevPosition
        var p1 = position

        if position.x > prevPosition.x {
            p0.x += dx - 0.5
            p1.x -= dx + 1.5
        }
        else if position.x < prevPosition.x {
            p0.x -= dx - 0.5
            p1.x += dx + 1.5
        }

        if position.y > prevPosition.y {
            p0.y += dy - 0.5
            p1.y -= dy + 1.5
        }
        else if position.y < prevPosition.y {
            p0.y -= dy - 0.5
            p1.y += dy + 1.5
        }

        if position.x == prevPosition.x && position.y != prevPosition.y {
            p0.x -= dx * 6 / 8
            p1.x -= dx * 6 / 8
        }
        else if position.x > prevPosition.x && position.y > prevPosition.y {
            p0.x += 0.5
            p1.x += 1
            p1.y += 0.25
        }
        else if position.x > prevPosition.x && position.y < prevPosition.y {
            p0.x += 0.5
            p1.x += 1
            p1.y -= 0.25
        }
        else if position.x < prevPosition.x && position.y > prevPosition.y {
            p0.x -= 0.5
            p1.x -= 1
            p1.y += 0.25
        }
        else if position.x < prevPosition.x && position.y < prevPosition.y {
            p0.x -= 0.5
            p1.x -= 1
            p1.y -= 0.25
        }

        let length = p0.distanceTo(p1)
        let color = enabled ? WhiteColor : 0x808080
        let line = SKSpriteNode(id: .ColorLine(length: length, color: color))
        line.anchorPoint = CGPoint(x: 0, y: 0.5)
        line.position = p0
        line.zRotation = p0.angleTo(p1)
        return line
    }
}
