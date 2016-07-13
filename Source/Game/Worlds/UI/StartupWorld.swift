////
///  StartupWorld.swift
//

class StartupWorld: World {
    var playerNode = BasePlayerNode()

    override func populateWorld() {
        defaultNode = playerNode
        self << playerNode

        setScale(2)
        let zoomingComponent1 = ScaleToComponent()
        zoomingComponent1.target = 1.0
        zoomingComponent1.rate = 0.25

        let zoomingComponent2 = ScaleToComponent()
        zoomingComponent2.target = 0.5
        zoomingComponent2.rate = 0.025

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
        timeline.every(3, start: .At(13), times: 4) {
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

        timeline.at(50) {
            self.director?.presentWorld(MainMenuWorld())
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
            let x: CGFloat = rand(min: -size.width, max: size.width)
            let y: CGFloat = rand(min: -size.height, max: size.height)
            let location = CGPoint(
                x: x / xScale,
                y: y / xScale
            )

            let explosion = EnemyExplosionNode(at: location)
            self << explosion
        }
    }

    func drawTitle() {
        Defaults["hasSeenStartup"] = true
        var y: CGFloat = 30
        for text in ["FLATOUT", "WAR"] {
            let textNode = TextNode()
            textNode.position = CGPoint(x: 0, y: y)
            textNode.font = .Big
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
