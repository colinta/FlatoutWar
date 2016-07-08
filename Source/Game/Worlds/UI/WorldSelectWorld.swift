////
///  WorldSelectWorld.swift
//


class WorldSelectWorld: World {
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
        pauseable = false
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

        let tutorialConfig = TutorialConfigSummary()
        let baseConfig = BaseConfigSummary()

        do {
            let button = Button(at: worldLocations[.Tutorial]!)
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

        if animate {
            timeline.after(1) { self.interactionEnabled = true }
            worldSelect.fadeTo(0, duration: 1)
            worldSelect.scaleTo(1.5, duration: 1)
            moveCamera(to: levelLocation, duration: 1)
            levelSelect.fadeTo(1, start: 0, duration: 1)
            levelSelect.scaleTo(1, start: 0.5, duration: 1)
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
            self.timeline.after(1) { self.interactionEnabled = true }
            levelSelect.fadeTo(0, duration: 1, removeNode: true)
            levelSelect.scaleTo(0.5, duration: 1)
            self.worldSelect.fadeTo(1, duration: 1)
            self.worldSelect.scaleTo(1, duration: 1)
            self.moveCamera(to: .zero, duration: 1)
        }
        levelSelect << backButton

        return levelSelect
    }

// MARK: TUTORIAL
    func transitionToTutorial(animate animate: Bool = true) {
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

        let enemyPositions = [
            CGPoint(x: 180, y:-20),
            CGPoint(x: 200, y:-20),
            CGPoint(x: 220, y:-20),
            CGPoint(x: 180, y:  0),
            CGPoint(x: 200, y:  0),
            CGPoint(x: 220, y:  0),
            CGPoint(x: 180, y: 20),
            CGPoint(x: 200, y: 20),
            CGPoint(x: 220, y: 20),
        ]
        for pos in enemyPositions {
            let enemyNode = EnemySoldierNode(at: pos)
            let wanderingComponent = WanderingComponent()
            wanderingComponent.centeredAround = pos
            enemyNode.addComponent(wanderingComponent)
            levelSelect << enemyNode
        }

        var prevLevel: Level?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, Level)] = [
            (1, 1, TutorialLevel1()),
            (2, 1, TutorialLevel2()),
            (2, 2, TutorialLevel3()),
            (2, 3, TutorialLevel4()),
            (3, 3, TutorialLevel5()),
            (3, 2, TutorialLevel6()),
        ]
        let d: CGFloat = 65
        for (xd, yd, level) in levels {
            let x: CGFloat = (xd - 2) * d
            let y: CGFloat = (yd - 2) * d
            let position = CGPoint(x, y)
            let button = generateButton(at: position, level: level, prevLevel: prevLevel)
            button.text = "\(levelIndex + 1)"
            levelSelect << button
            prevLevel = level
            levelIndex += 1
        }
    }

// MARK: BASE
    func transitionToBase(animate animate: Bool = true) {
        let levelSelect = transitionToLevel(at: worldLocations[.Base]!, animate: animate)

        let tutorialTitle = TextNode(at: CGPoint(y: 130))
        tutorialTitle.font = .Big
        tutorialTitle.text = "BASE"
        levelSelect << tutorialTitle

        let enemyPositions = [
            CGPoint(x: 180, y:-20),
            CGPoint(x: 200, y:-20),
            CGPoint(x: 220, y:-20),
            CGPoint(x: 180, y:  0),
            CGPoint(x: 200, y:  0),
            CGPoint(x: 220, y:  0),
            CGPoint(x: 180, y: 20),
            CGPoint(x: 200, y: 20),
            CGPoint(x: 220, y: 20),
            ]
        for pos in enemyPositions {
            let enemyNode = EnemySoldierNode(at: pos)
            let wanderingComponent = WanderingComponent()
            wanderingComponent.centeredAround = pos
            enemyNode.addComponent(wanderingComponent)
            levelSelect << enemyNode
        }

        var prevLevel: Level?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, Level)] = [
            (1, 1, BaseLevel1()),
            (2, 1, BaseLevel2()),
            (3, 1, BaseLevel3()),
            (3, 2, BaseLevel4()),
            (3, 3, BaseLevel5()),
            ]
        let d: CGFloat = 65
        for (xd, yd, level) in levels {
            let x: CGFloat = (xd - 2) * d
            let y: CGFloat = (yd - 2) * d
            let position = CGPoint(x, y)

            let upgrade = UpgradeWorld()
            upgrade.nextWorld = level
            let button = generateButton(
                at: position,
                level: level, prevLevel: prevLevel,
                presentWorld: upgrade)
            button.text = "\(levelIndex + 1)"
            levelSelect << button
            prevLevel = level
            levelIndex += 1
        }
    }

}

extension WorldSelectWorld {
    func generateButton(at center: CGPoint, level: Level, prevLevel: Level?, presentWorld: World? = nil) -> Button {
        let button = Button(at: center)
        let completed = prevLevel?.config.levelCompleted ?? true
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
}
