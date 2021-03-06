////
///  TutorialSelectWorld.swift
//

class TutorialSelectWorld: World {

    override func populateWorld() {
        let worlds: [(String, () -> World)] = [
            ("AUTO AIMING", { return AutoFireTutorial() }),
            ("POWERUPS", { return PowerupTutorial() }),
            ("RAPID FIRE", { return RapidFireTutorial() }),
            ("DODEC DRONE", { return DroneTutorial() }),
            ("PLAYGROUND", { return Playground() }),
        ]

        let textNode = TextNode(at: CGPoint(x: -165, y: -125))
        textNode.text = "TUTORIALS"
        textNode.font = .big
        self << textNode

        let backButton = Button(at: CGPoint(x: -200, y: 100))
        backButton.text = "<"
        backButton.font = .big
        backButton.size = CGSize(width: 15, height: 15)
        backButton.onTapped { [unowned self] in
            self.director?.presentWorld(WorldSelectWorld(beginAt: .tutorial))
        }
        self << backButton

        let enemyPositions = [
            CGPoint(x: 170, y:-30),
            CGPoint(x: 200, y:-30),
            CGPoint(x: 230, y:-30),
            CGPoint(x: 170, y:  0),
            CGPoint(x: 200, y:  0),
            CGPoint(x: 230, y:  0),
            CGPoint(x: 170, y: 30),
            CGPoint(x: 200, y: 30),
            CGPoint(x: 230, y: 30),
        ]
        for pos in enemyPositions {
            let enemyNode = EnemyJetNode(at: pos)
            let wanderingComponent = WanderingComponent()
            wanderingComponent.centeredAround = pos
            wanderingComponent.wanderingRadius = 40
            enemyNode.addComponent(wanderingComponent)
            self << enemyNode
        }

        var levelIndex = 0
        for (name, worldFn) in worlds {
            let world = worldFn()
            let y = CGFloat(100 - 35 * levelIndex)
            let center = CGPoint(x: 40, y: y)
            let button = Button(at: center)
            button.text = name
            button.size.height = 25
            button.onTapped {
                self.director?.presentWorld(world)
            }
            self << button
            levelIndex += 1
        }
    }

}
