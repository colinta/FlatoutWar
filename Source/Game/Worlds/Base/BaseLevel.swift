//
//  BaseLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel: Level {
    var playerNode: BasePlayerNode! {
        didSet {
            self.updatePlayer(playerNode)
        }
    }
    var shouldReturnToLevelSelect = false
    private var _config: BaseConfig?
    var config: BaseConfig {
        if let config = _config {
            return config
        }
        let config = loadConfig()
        _config = config
        return config
    }

    func loadConfig() -> BaseConfig {
        fatalError("init(coder:) has not been implemented")
    }

    func tutorial() -> Tutorial { fatalError("tutorial() has not been implemented in \(self.dynamicType)") }

    required init() {
        super.init()

        playerNode = BasePlayerNode()
        updatePlayer(playerNode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updatePlayer(node: Node) {
        node.healthComponent?.onKilled {
            if self.playerNode == node {
                self.levelCompleted(success: false)
            }
        }
    }

    override func populateWorld() {
        super.populateWorld()
        defaultNode = playerNode
        self << playerNode

        timeline.when({ self.possibleExperience >= self.config.possibleExperience }) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }

    override func goToNextWorld() {
        if shouldReturnToLevelSelect {
            director?.presentWorld(LevelSelectWorld())
        }
        else {
            let nextLevel = self.nextLevel()
            self.director?.presentWorld(nextLevel.tutorialOrLevel())
        }
    }

}

extension BaseLevel {

    func tutorialOrLevel() -> World {
        if config.hasTutorial && !config.seenTutorial {
            config.seenTutorial = true

            let tutorial = self.tutorial()
            tutorial.nextWorld = self
            return tutorial
        }
        else if config.canUpgrade {
            let upgradeWorld = BaseUpgradeWorld()
            upgradeWorld.nextWorld = self
            return upgradeWorld
        }
        return self
    }


}

extension BaseLevel {

    func nextLevel() -> BaseLevel {
        fatalError("nextLevel() has not been implemented by \(self.dynamicType)")
    }

    override func levelCompleted(var success success: Bool) {
        // sanity check against a kamikaze triggering a "successful" completion
        if let died = playerNode.healthComponent?.died where died {
            success = false
        }

        super.levelCompleted(success: success)

        let finalTimeline = TimelineComponent()
        addComponent(finalTimeline)

        for node in players + enemies {
            node.enabled = false
        }

        if success {
            config.gainedExperience = gainedExperience
            nextLevel().config.storedPlayers = self.players

            let percentNode = PercentBar(at: CGPoint(x: 50, y: 0))
            self << percentNode

            let totalText = TextNode(at: CGPoint(x: 100, y: 4))
            totalText.text = "\(possibleExperience)"
            totalText.font = .Small
            self << totalText

            let currentText = TextNode(at: CGPoint(x: 30, y: -20))
            currentText.text = "0"
            currentText.font = .Small
            self << currentText

            let maxCount = CGFloat(gainedExperience)
            var countEmUp = CGFloat(0)
            var countEmUpIncrement = CGFloat(0.1)
            let countEmUpRate = CGFloat(0.03)
            finalTimeline.every(countEmUpRate, startAt: 2, until: { countEmUp >= maxCount }) {
                countEmUp = min(countEmUp + countEmUpIncrement, maxCount)
                countEmUpIncrement *= 1.05

                percentNode.complete = countEmUp / CGFloat(self.possibleExperience)
                currentText.text = "\(Int(round(countEmUp * 10)) / 10)"
                currentText.position.x = CGFloat(30) + percentNode.complete * percentNode.size.width
            }

            finalTimeline.when({ countEmUp >= maxCount }) {
                currentText.text = "\(self.gainedExperience)"

                self.backButton.visible = true
                self.nextButton.visible = true
            }

            finalTimeline.every(1) {
                let explosion = EnemyExplosionNode(at: CGPoint(x: ±rand(self.size.width / 4), y: ±rand(self.size.height / 4)))
                self << explosion
            }
        }
        else {
            let playerCenter = playerNode.position
            playerNode.removeFromParent()
            let explosion = PlayerExplosionNode(at: playerCenter)
            self << explosion

            quitButton.visible = true
            restartButton.visible = true

            finalTimeline.every(2) {
                let explosion = PlayerExplosionNode(at: playerCenter)
                self << explosion
            }
        }
    }

}

extension BaseLevel {

    func introduceDrone() -> DroneNode {
        let drone = DroneNode()
        drone.position = playerNode.position
        self << drone
        customizeNode(drone)

        return drone
    }

}

extension BaseLevel {

    func customizeNode(node: Node) {
        if let drone = node as? DroneNode {
            drone.draggableComponent?.maintainDistance(100, around: playerNode)
            drone.alpha = 0

            let fadeIn = FadeToComponent()
            fadeIn.target = 1
            fadeIn.duration = 1.4
            fadeIn.removeComponentOnFade()
            drone.addComponent(fadeIn)

            drone.draggableComponent?.target = drone.position
            drone.position = playerNode.position
        }
    }

}

extension BaseLevel {

    func generateEnemy(genAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false)() {
        var angle = genAngle
        if spread > 0 {
           angle = angle ± rand(spread)
        }

        let enemyNode = EnemySoldierNode()
        if constRadius {
            enemyNode.position = CGPoint(r: outerRadius, a: angle)
        }
        else {
            enemyNode.position = outsideWorld(enemyNode, angle: angle)
        }
        self << enemyNode
    }

    func generateLeaderEnemy(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let enemyNode = EnemyLeaderNode()
        enemyNode.position = outsideWorld(enemyNode, angle: angle)
        self << enemyNode
    }

    func generateEnemyFormation(angle: CGFloat)() {
        let dist = CGFloat(25)
        let enemyLeader = EnemyLeaderNode()
        let center = outsideWorld(extra: enemyLeader.radius + dist * 1.5, angle: angle)
        enemyLeader.position = center
        self << enemyLeader

        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)
        let back = center + CGVector(r: dist, a: angle)
        let back2 = center + CGVector(r: 2 * dist, a: angle)

        let origins = [
            center + left,
            center + right,
            back + left,
            back,
            back + right,
            back2 + left,
            back2,
            back2 + right,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

    func generateEnemyPair(angle: CGFloat)() {
        let dist = CGFloat(5)
        let ghost = generateEnemyGhost(angle: angle, extra: 10)

        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)

        let origins = [
            ghost.position + left,
            ghost.position + right,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.follow(ghost)
            self << enemy
        }
    }

    func generateDozer(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let enemyCount = 4
        let height = CGFloat((enemyCount * 12) + 2)
        let dozer = EnemyDozerNode()
        dozer.position = outsideWorld(dozer, angle: angle)
        self << dozer

        let min = -height / 2 + 5
        let max = height / 2 - 5
        for i in 0..<enemyCount {
            let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
            let location = dozer.position + CGPoint(r: 10, a: angle) + CGPoint(r: r, a: angle + 90.degrees)
            let enemy = EnemySoldierNode(at: location)
            enemy.follow(dozer, scatter: false)
            self << enemy
        }
    }

    func generateScouts(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        let d = CGFloat(8)
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        for i in 0..<3 {
            let enemyNode = EnemyScoutNode()
            enemyNode.position = outsideWorld(enemyNode, angle: angle) + CGPoint(r: CGFloat(i) * d, a: angle)
            self << enemyNode
        }
    }

    func generateJet(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        let jet = EnemyJetNode()
        jet.name = "jet"
        jet.position = self.outsideWorld(jet, angle: genAngle) + CGPoint(y: ±rand(spread))
        self << jet
    }

    func generateLeaderWithLinearFollowers(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let dist = CGFloat(25)
        let enemyLeader = EnemyLeaderNode()
        let leaderPosition = outsideWorld(enemyLeader, angle: angle)
        enemyLeader.position = leaderPosition
        self << enemyLeader

        for i in 0...4 {
            let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: angle)
            let enemy = EnemySoldierNode(at: location)
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

    func generateLeaderWithCircularFollowers(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }

        let ghost = generateEnemyGhost(angle: angle, extra: 40)

        let dist = CGFloat(30)
        var enemies: [Node] = []
        let enemyLeader = EnemyLeaderNode()
        enemyLeader.name = "enemyLeader"
        let leaderPosition = ghost.position + CGPoint(r: dist + enemyLeader.radius, a: angle)
        enemyLeader.position = leaderPosition
        enemyLeader.follow(ghost)
        self << enemyLeader
        enemies << enemyLeader

        let count = 5
        let angleDelta = TAU / CGFloat(count)
        for i in 0..<count {
            let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 2)
            let vector = CGVector(r: dist, a: enemyAngle)
            let enemy = EnemySoldierNode(at: leaderPosition + vector)
            enemy.follow(ghost)
            self << enemy
            enemies << enemy
            enemy.name = "enemy"
        }

       ghost.enemyComponent!.onTargetAcquired { target in
           if let target = target {
               for enemy in enemies {
                   enemy.rotateTowards(target)
               }
           }
       }
    }

    private func generateEnemyGhost(angle angle: CGFloat, extra: CGFloat = 0) -> Node {
        let position = outsideWorld(extra: extra, angle: angle)
        let enemyGhost = Node(at: position)
        enemyGhost.name = "enemyGhost"
        let enemyComponent = EnemyComponent()
        enemyComponent.targetable = false
        enemyGhost.addComponent(enemyComponent)

        let rammingComponent = RammingComponent()
        rammingComponent.intersectionNode = enemyGhost
        rammingComponent.removeNodeOnRammed()
        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(enemyComponent: enemyComponent)
        self << enemyGhost

        return enemyGhost
    }

}
