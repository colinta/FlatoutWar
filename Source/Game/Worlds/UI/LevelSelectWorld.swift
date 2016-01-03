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

        let worlds: [() -> World] = [
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
            // { return BaseLevel12() },
            // { return BaseLevel13() },
            // { return BaseLevel14() },
            // { return BaseLevel15() },
            // { return BaseLevel16() },
            { return AutoFireTutorial() },
            { return RapidFireTutorial() },
            { return DemoWorld() },
            { return CameraDemoWorld() },
            { return IntersectsTestWorld() },
        ]

        let textNode = TextNode(at: CGPoint(x: -165, y: -125))
        textNode.text = "BASE"
        self << textNode

        let backButton = ButtonNode(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped { [unowned self] in
            self.director?.presentWorld(MainMenuWorld())
        }
        self << backButton

        let positions = [
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
        for pos in positions {
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
                let button = ButtonNode(at: center)
                button.enabled = levelIndex <= completed
                button.text = "\(levelIndex + 1)"
                button.size = CGSize(50)
                button.style = .Square
                button.onTapped {
                    let nextWorld = worlds[myIndex % worlds.count]()
                    if let nextWorld = nextWorld as? BaseLevel {
                        nextWorld.shouldReturnToLevelSelect = true
                    }
                    self.director?.presentWorld(nextWorld)
                }
                self << button
                levelIndex += 1
            }
        }
    }

}
