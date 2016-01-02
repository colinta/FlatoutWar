//
//  LevelSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class LevelSelectWorld: World {

    private func worldAtIndex(index: Int) -> World {
        let worlds: [() -> World] = [
            // { return BaseCampaign_Level1() },
            // { return BaseCampaign_Level2() },
            // { return BaseCampaign_Level3() },
            // { return BaseCampaign_Level4() },
            // { return BaseCampaign_Level5() },
            // { return BaseCampaign_Level6() },
            // { return BaseCampaign_Level7() },
            // { return BaseCampaign_Level8() },
            // { return BaseCampaign_Level9() },
            // { return BaseCampaign_Level10() },
            // { return BaseCampaign_Level11() },
            // { return BaseCampaign_Level12() },
            // { return BaseCampaign_Level13() },
            // { return BaseCampaign_Level14() },
            // { return BaseCampaign_Level15() },
            { return DemoWorld() },
            { return CameraDemoWorld() },
        ]
        return worlds[index % worlds.count]()
    }

    override func populateWorld() {
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
            enemyNode.addComponent(WanderingComponent())
            self << enemyNode
        }

        var levelIndex = 0
        let completed = 5
        for j in 0..<4 {
            let y = CGFloat(-70 + 60 * j)
            for i in 0..<4 {
                let x = CGFloat(-80 + 60 * i)
                let myIndex = levelIndex
                let center = CGPoint(x: x, y: y)
                let button = ButtonNode(at: center)
                button.enabled = levelIndex <= completed
                button.text = "\(levelIndex + 1)"
                button.size = CGSize(width: 15, height: 15)
                button.onTapped {
                    self.director?.presentWorld(self.worldAtIndex(myIndex))
                }
                self << button
                levelIndex += 1
            }
        }
    }

}
