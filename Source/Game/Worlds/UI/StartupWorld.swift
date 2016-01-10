//
//  StartupWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class StartupWorld: World {
    var playerNode = BasePlayerNode()

    override func populateWorld() {
        pauseable = false

        defaultNode = playerNode
        self << playerNode

        setScale(2)
        let zoomingComponent1 = ZoomToComponent()
        zoomingComponent1.target = 1.0

        let zoomingComponent2 = ZoomToComponent()
        zoomingComponent2.rate = 0.025
        zoomingComponent2.target = 0.5

        timeline.at(1) {
            self.addComponent(zoomingComponent1)
        }

        timeline.at(5) {
            let enemyNode1 = EnemySoldierNode()
            enemyNode1.position = self.outsideWorld(angle: 0)
            enemyNode1.zRotation = TAU_2
            self << enemyNode1

            let enemyNode2 = EnemySoldierNode()
            enemyNode2.position = self.outsideWorld(angle: 10.degrees)
            enemyNode2.zRotation = TAU_2
            self << enemyNode2
        }

        timeline.at(10) {
            let enemy = EnemySoldierNode()
            enemy.position = self.outsideWorld(enemy, angle: 135.degrees)
            enemy.zRotation = 0
            self << enemy
        }
        timeline.every(3, startAt: 13, times: 4) {
            self.spawn()
        }

        timeline.at(15) {
            zoomingComponent1.removeFromNode()
            self.addComponent(zoomingComponent2)
        }

        timeline.at(25) {
            for _ in 0..<100 {
                let enemy = self.spawn(rand(min: 600, max: 800))
                enemy.rammingComponent?.maxSpeed = 50
            }

            for _ in 0..<3 {
                let enemy = self.spawnGiant(rand(min: 600, max: 800))
                enemy.healthComponent?.startingHealth = 2000
            }
        }

        timeline.at(30) {
            for node in self.nodes {
                node.addComponent(FadeToComponent(fadeOut: 8))
            }
        }

        timeline.at(37) {
            self.timeline.every(1) {
                self.explosions()
            }
        }

        timeline.at(41) {
            zoomingComponent2.removeFromNode()
            self.setScale(2)

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

    override func didAdd(node: Node) {
        super.didAdd(node)
        if node.isEnemy || node.isPlayer || node.isProjectile {
            node.alpha = playerNode.alpha
        }
    }

    func explosions(count: Int = 3) {
        for _ in 0..<count {
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
        let radius = (_radius ?? outerRadius / xScale)
        let enemyNode = EnemySoldierNode()
        enemyNode.position = CGPoint(r: radius, a: rand(TAU))
        enemyNode.rotateTowards(playerNode)
        self << enemyNode
        return enemyNode
    }

    func spawnGiant(_radius: CGFloat? = nil) -> EnemySoldierNode {
        let radius = (_radius ?? outerRadius / xScale)
        let enemyNode = EnemyGiantNode()
        enemyNode.position = CGPoint(r: radius, a: rand(TAU))
        enemyNode.rotateTowards(playerNode)
        self << enemyNode
        return enemyNode
    }

}
