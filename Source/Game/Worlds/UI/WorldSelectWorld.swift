//
//  WorldSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/16/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//


class WorldSelectWorld: World {
    var worldLocations: [Level: CGPoint]!
    var worldSelect: Node!
    var beginAt: Level = .Select

    enum Level {
        case PanIn
        case Select
        case Tutorial
        case Base
    }

    convenience init(beginAt: Level) {
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

        do {
            let button = Button(at: worldLocations[.Tutorial]!)
            button.style = .SquareSized(50)
            button.font = .Big
            button.onTapped {
                self.transitionTo0()
            }
            button.text = "0"
            worldSelect << button
        }

        do {
            let button = Button(at: worldLocations[.Base]!)
            button.style = .SquareSized(50)
            button.font = .Big
            button.enabled = TutorialConfigSummary().worldCompleted
            button.onTapped {
                self.transitionTo1()
            }
            button.text = "1"
            worldSelect << button
        }

        switch beginAt {
        case .Tutorial:
            transitionTo0(animate: false)
        case .Base:
            transitionTo1(animate: false)
        default: break
        }
    }

    func transitionToLevel(at at: CGPoint, animate: Bool) -> Node {
        let levelSelect = Node()
        levelSelect.position = worldLocations[.Tutorial]!
        self << levelSelect

        if animate {
            worldSelect.fadeTo(0, duration: 1)
            worldSelect.scaleTo(1.5, duration: 1)
            moveCamera(to: worldLocations[.Tutorial]!, duration: 1)
            levelSelect.fadeTo(1, start: 0, duration: 1)
            levelSelect.scaleTo(1, start: 0.5, duration: 1)
        }
        else {
            worldSelect.alpha = 0
            worldSelect.setScale(1.5)
            moveCamera(from: worldLocations[.Tutorial]!)
            levelSelect.alpha = 1
            levelSelect.setScale(1)
        }

        let backButton = Button(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.font = .Big
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped { [unowned self] in
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
    func transitionTo0(animate animate: Bool = true) {
        let levelSelect = transitionToLevel(at: worldLocations[.Tutorial]!, animate: animate)

        let tutorialButton = Button(at: CGPoint(x: -200, y: 20))
        tutorialButton.text = "?"
        tutorialButton.font = .Big
        tutorialButton.size = CGSize(width: 15, height: 15)
        tutorialButton.onTapped { [unowned self] in
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

        var prevLevel: BaseLevel?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, BaseLevel)] = [
            (1, 1, TutorialLevel1()),
            (2, 1, TutorialLevel2()),
            (2, 2, TutorialLevel3()),
            (2, 3, TutorialLevel4()),
            (3, 3, TutorialLevel5()),
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
    func transitionTo1(animate animate: Bool = true) {
        let levelSelect = transitionToLevel(at: worldLocations[.Base]!, animate: animate)


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

        var prevLevel: BaseLevel?
        var levelIndex = 0
        let levels: [(CGFloat, CGFloat, BaseLevel)] = [
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
            let button = generateButton(at: position, level: level, prevLevel: prevLevel, present: upgrade)
            button.text = "\(levelIndex + 1)"
            levelSelect << button
            prevLevel = level
            levelIndex += 1
        }
    }

}

extension WorldSelectWorld {
    func generateButton(at center: CGPoint, level: BaseLevel, prevLevel: BaseLevel?, present presentWorld: World? = nil) -> Button {
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
            let amt: CGFloat = level.config.percentGainedExperience
            let box = SKSpriteNode()
            let boxSize = CGSize(width: button.size.width, height: amt * button.size.height)
            box.position.y = -(button.size.height - boxSize.height) / 2
            let color: Int
            if level.config.gainedExperience == level.config.possibleExperience {
                color = 0xA0D3A0 // green
            }
            else {
                let red: (CGFloat, CGFloat)
                let green: (CGFloat, CGFloat)
                let blue: (CGFloat, CGFloat)
                if amt < 0.5 {
                    let target = 0xA83846  // red
                    red = (0, 2 * CGFloat(target >> 16 & 0xff))
                    green = (0, 2 * CGFloat(target >> 8 & 0xff))
                    blue = (0, 2 * CGFloat(target & 0xff))
                }
                else {
                    let target = 0xF1EC3E  // yellow
                    red = (0, CGFloat(target >> 16 & 0xff))
                    green = (0, CGFloat(target >> 8 & 0xff))
                    blue = (0, CGFloat(target & 0xff))
                }
                color = Int(
                    red: Int(interpolate(amt, from: (0, 1), to: red)),
                    green: Int(interpolate(amt, from: (0, 1), to: green)),
                    blue: Int(interpolate(amt, from: (0, 1), to: blue))
                )
            }
            box.textureId(.FillColorBox(size: boxSize, color: color))
            box.alpha = 1
            box.z = .Bottom
            button << box
        }
        return button
    }
}
