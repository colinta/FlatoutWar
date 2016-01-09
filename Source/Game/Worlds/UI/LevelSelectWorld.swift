//
//  LevelSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class LevelSelectWorld: World {

    override func populateWorld() {
        pauseable = false

        let worlds: [() -> BaseLevel] = [
            { return BaseLevel1() },
            { return BaseLevel2() },
            { return BaseLevel3() },
            { return BaseLevel4() },
            { return BaseLevel5() },
            { return BaseLevel6() },
            { return BaseLevel7() },
            { return BaseLevel8() },
            { return BaseLevel9() },
            { return BaseLevel10() },
            { return BaseLevel11() },
            { return BaseLevel12() },
            { return BaseLevel13() },
            { return BaseLevel14() },
            { return BaseLevel15() },
            { return BaseLevel16() },
        ]

        let textNode = TextNode(at: CGPoint(x: -165, y: -125))
        textNode.text = "BASE"
        self << textNode

        let backButton = Button(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped { [unowned self] in
            self.director?.presentWorld(MainMenuWorld())
        }
        self << backButton

        let tutorialButton = Button(at: CGPoint(x: -200, y: 20))
        tutorialButton.text = "?"
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
        let completed = worlds.count
        for j in 0..<4 {
            let y = CGFloat(100 - 60 * j)
            for i in 0..<4 {
                let x = CGFloat(-80 + 60 * i)
                let myIndex = levelIndex
                let center = CGPoint(x: x, y: y)
                let button = Button(at: center)
                button.enabled = levelIndex < completed
                button.text = "\(levelIndex + 1)"
                button.size = CGSize(50)
                button.style = .Square
                button.onTapped {
                    let nextLevel = worlds[myIndex % worlds.count]()
                    nextLevel.shouldReturnToLevelSelect = true
                    self.director?.presentWorld(nextLevel.tutorialOrLevel())
                }
                self << button
                levelIndex += 1
            }
        }
    }

}
