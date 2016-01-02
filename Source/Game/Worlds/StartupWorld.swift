//
//  StartupWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class StartupWorld: World {
    var playerNode: BasePlayerNode

    required init() {
        playerNode = BasePlayerNode()
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func populateWorld() {
        defaultNode = playerNode
        self << playerNode

        setScale(2)
        let zoomingComponent1 = ZoomToComponent()
        zoomingComponent1.target = 1.0

        let zoomingComponent2 = ZoomToComponent()
        zoomingComponent2.rate = 0.025
        zoomingComponent2.target = 0.5

        let zoomingComponent3 = ZoomToComponent()
        zoomingComponent3.rate = 2
        zoomingComponent3.target = 2

        timeline.at(1) {
            self.addComponent(zoomingComponent1)
        }

        timeline.at(5) {
            let enemyNode1pt = CGPoint(r: self.size.width/2, a: 0)

            let enemyNode1 = EnemySoldierNode()
            enemyNode1.position = enemyNode1pt
            enemyNode1.zRotation = TAU_2
            self << enemyNode1

            let enemyNode2pt = CGPoint(r: self.size.width/2 + 5, a: 10.degrees)
            let enemyNode2 = EnemySoldierNode()
            enemyNode2.position = enemyNode2pt
            enemyNode2.zRotation = TAU_2
            self << enemyNode2
        }

        timeline.at(10) {
            let enemy = EnemySoldierNode()
            enemy.position = CGPoint(r: self.worldRadius + 20, a: 175.degrees)
            enemy.zRotation = 0
            self << enemy
        }
        timeline.every(3, startAt: 13, times: 9) {
            self.spawn()
        }

        timeline.at(15) {
            zoomingComponent1.removeFromNode()
            self.addComponent(zoomingComponent2)
        }

        timeline.at(25) {
            for _ in 0..<100 {
                let enemy = self.spawn(rand(min: 400, max: 1000))
                enemy.rammingComponent?.maxSpeed = 50
            }

            for _ in 0..<3 {
                let enemy = self.spawnGiant(rand(min: 600, max: 800))
                enemy.healthComponent?.startingHealth = 2000
            }
        }

        timeline.at(40) {
            zoomingComponent2.removeFromNode()
            self.addComponent(zoomingComponent3)
        }

        timeline.at(41) {
            self << PlayerExplosionNode(at: self.playerNode.position)
            self.timeline.every(1) {
                self.explosion()
            }
            for enemy in self.enemies {
                enemy.rammingComponent?.enabled = false
                enemy.addComponent(RotateToComponent())
                enemy.addComponent(WanderingComponent())
            }
            self.playerNode.removeFromParent()
            self.drawTitle()

            let touchableComponent = TouchableComponent()
            touchableComponent.containsTouchTest = { _ in return true }
            touchableComponent.on(.Up) { _ in
                self.director?.presentWorld(MainMenuWorld())
            }
            let node = Node()
            node.addComponent(touchableComponent)
            self << node
            self.defaultNode = node
        }
    }

    func explosion() {
        for _ in 0..<3 {
            let x: CGFloat = rand(min: -size.width, max: size.width) as CGFloat
            let y: CGFloat = rand(min: -size.height, max: size.height) as CGFloat
            let location = CGPoint(
                x: x / xScale,
                y: y / xScale
            )

            let explosion = EnemyExplosionNode(at: location)
            self << explosion
        }
    }

    func drawTitle() {
        var y: CGFloat = 30
        for text in ["FLATOUT", "WAR"] {
            let textNode = TextNode()
            textNode.position = CGPoint(x: 0, y: y)
            y += textNode.size.height - 60
            textNode.text = text
            self << textNode
        }
    }

    func spawn(_radius: CGFloat? = nil) -> EnemySoldierNode {
        let radius = (_radius ?? worldRadius) + 20
        let location = CGPoint(r: radius, a: rand(TAU))
        let enemyNode = EnemySoldierNode(at: location)
        enemyNode.rotateTowards(playerNode)
        self << enemyNode
        return enemyNode
    }

    func spawnGiant(_radius: CGFloat? = nil) -> EnemySoldierNode {
        let radius = (_radius ?? worldRadius) + 20
        let location = CGPoint(r: radius, a: rand(TAU))
        let enemyNode = EnemyGiantNode(at: location)
        enemyNode.rotateTowards(playerNode)
        self << enemyNode
        return enemyNode
    }

}
