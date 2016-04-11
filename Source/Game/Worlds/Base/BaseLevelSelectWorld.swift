//
//  BaseLevelSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevelSelectWorld: World {

    override func populateWorld() {
        pauseable = false

        let worlds: [BaseLevel] = [
            BaseLevel1(),
            BaseLevel2(),
            BaseLevel3(),
            BaseLevel4(),
            BaseLevel5(),
            BaseLevel6(),
            BaseLevel7(),
            BaseLevel8(),
            BaseLevel9(),
        ]

        let textNode = TextNode(at: CGPoint(x: -165, y: -125))
        textNode.text = "BASE"
        textNode.font = .Big
        self << textNode

        let backButton = Button(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.font = .Big
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped { [unowned self] in
            self.director?.presentWorld(MainMenuWorld())
        }
        self << backButton

        let tutorialButton = Button(at: CGPoint(x: -200, y: 20))
        tutorialButton.text = "?"
        tutorialButton.font = .Big
        tutorialButton.size = CGSize(width: 15, height: 15)
        tutorialButton.onTapped { [unowned self] in
            self.director?.presentWorld(TutorialSelectWorld())
        }
        self << tutorialButton

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
            self << enemyNode
        }

        var levelIndex = 0
        var prevLevel: BaseLevel?
        for j in 0..<3 {
            let y = CGFloat(100 - 80 * j)
            for i in 0..<3 {
                let x = CGFloat(-80 + 80 * i)
                let level = worlds[levelIndex % worlds.count]
                let center = CGPoint(x: x, y: y)
                let button = Button(at: center)
                let completed = prevLevel?.config.levelCompleted ?? true
                button.enabled = completed
                button.text = "\(levelIndex + 1)"
                button.size = CGSize(50)
                button.style = .Square
                button.font = .Big
                button.onTapped {
                    level.shouldReturnToLevelSelect = true
                    self.director?.presentWorld(level.tutorialOrLevel())
                }
                self << button
                prevLevel = level
                levelIndex += 1

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
            }
        }
    }

}
