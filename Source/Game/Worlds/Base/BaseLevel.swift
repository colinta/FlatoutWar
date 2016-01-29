//
//  BaseLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel: Level {
    private var shouldPopulatePlayer = false
    var playerNode = BasePlayerNode() {
        willSet {
            if playerNode != newValue {
                playerNode.removeFromParent()
            }
        }
        didSet {
            updatePlayer(playerNode)
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

    required init() {
        super.init()
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

        self << playerNode
        defaultNode = playerNode
    }

    override func populateWorld() {
        super.populateWorld()

        if config.canUpgrade {
            for node in config.storedPlayers {
                customizeNode(node)
            }
        }

        shouldPopulatePlayer = true
        updatePlayer(playerNode)

        timeline.when({ self.possibleExperience >= self.config.possibleExperience }) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }

    override func goToLevelSelect() {
        director?.presentWorld(BaseLevelSelectWorld())
    }

    override func goToNextWorld() {
        if shouldReturnToLevelSelect {
            director?.presentWorld(BaseLevelSelectWorld())
        }
        else {
            let nextLevel = config.nextLevel()
            self.director?.presentWorld(nextLevel.tutorialOrLevel())
        }
    }

}

extension BaseLevel {

    func tutorialOrLevel() -> World {
        if let tutorial = config.tutorial() where !config.seenTutorial {
            config.seenTutorial = true

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

    override func levelCompleted(var success success: Bool) {
        // sanity check against a kamikaze triggering a "successful" completion
        if let died = playerNode.healthComponent?.died where died {
            success = false
        }

        super.levelCompleted(success: success)

        let finalTimeline = TimelineComponent()
        addComponent(finalTimeline)

        for node in players + enemies {
            node.frozen = true
        }

        if success {
            config.updateMaxGainedExperience(gainedExperience)
            config.nextLevel().config.storedPlayers = self.players

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
            var countEmUp: CGFloat = 0
            var countEmUpIncrement: CGFloat = 0.1
            let countEmUpRate: CGFloat = 0.03
            finalTimeline.every(countEmUpRate, startAt: 2, until: { countEmUp >= maxCount }) {
                countEmUp = min(countEmUp + countEmUpIncrement, maxCount)
                countEmUpIncrement *= 1.05

                percentNode.complete = countEmUp / CGFloat(self.possibleExperience)
                currentText.text = "\(Int(round(countEmUp * 10)) / 10)"
                currentText.position.x = CGFloat(30) + percentNode.complete * percentNode.size.width
            }

            finalTimeline.when({ countEmUp >= maxCount }) {
                currentText.text = "\(self.gainedExperience)"

                if self.shouldReturnToLevelSelect {
                    self.backButton.visible = true
                    self.backButton.fixedPosition = .Bottom(x: 0, y: 100)
                }
                else {
                    self.backButton.visible = true
                    self.nextButton.visible = true
                }
            }

            finalTimeline.every(1) {
                let explosion = EnemyExplosionNode(at: CGPoint(x: ±rand(self.size.width / 4), y: ±rand(self.size.height / 4)))
                self << explosion
            }
        }
        else {
            let playerCenter = playerNode.position
            playerNode.removeFromParent()
            let explosion = PlayerExplosionNode()
            explosion.position = playerCenter
            self << explosion

            quitButton.visible = true
            restartButton.visible = true
        }
    }

}

extension BaseLevel {

    func introduceDrone() {
        let drone = DroneNode()
        drone.position = CGPoint(-30, -60)
        customizeNode(drone)
    }

}

extension BaseLevel {

    func customizeNode(node: Node) {
        if let playerNode = node as? BasePlayerNode {
            self.playerNode = playerNode
        }
        else if let drone = node as? DroneNode {
            drone.alpha = 0

            let fadeIn = FadeToComponent()
            fadeIn.target = 1
            fadeIn.duration = 1.4
            fadeIn.removeComponentOnFade()
            drone.addComponent(fadeIn)

            self << drone
        }

        node.draggableComponent?.maintainDistance(100, around: playerNode)
    }

}

extension BaseLevel {

    func generateEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
           screenAngle = screenAngle ± rand(spread)
        }

        let enemyNode = EnemySoldierNode()
        enemyNode.name = "soldier"
        if constRadius {
            enemyNode.position = CGPoint(r: outerRadius, a: screenAngle)
        }
        else {
            enemyNode.position = outsideWorld(enemyNode, angle: screenAngle)
        }
        self << enemyNode
    }

    func generateLeaderEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
            screenAngle = screenAngle ± rand(spread)
        }
        let enemyNode = EnemyLeaderNode()
        enemyNode.name = "leader"
        enemyNode.position = outsideWorld(enemyNode, angle: screenAngle)
        self << enemyNode
    }

    func generateScouts(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        let d: CGFloat = 8
        if spread > 0 {
            screenAngle = screenAngle ± rand(spread)
        }
        for i in 0..<3 {
            let enemyNode = EnemyScoutNode()
            enemyNode.name = "scout"
            enemyNode.position = outsideWorld(enemyNode, angle: screenAngle) + CGPoint(r: CGFloat(i) * d, a: screenAngle)
            self << enemyNode
        }
    }

    func generateJet(genScreenAngle: CGFloat, spread: CGFloat = 0)() {
        let jet = EnemyJetNode()
        jet.name = "jet"
        jet.position = self.outsideWorld(jet, angle: genScreenAngle)

        let angle = normalizeAngle(jet.position.angle)
        let sizeAngle = size.angle
        if angle > TAU - sizeAngle || angle <= sizeAngle {
            jet.position.y += ±spread
        }
        else if angle > TAU_2 + sizeAngle {
            jet.position.x += ±spread
        }
        else if angle > TAU_2 - sizeAngle {
            jet.position.y += ±spread
        }
        else {
            jet.position.x += ±spread
        }

        self << jet
    }

    func generateBigJet(genScreenAngle: CGFloat, spread: CGFloat = 0)() {
        let jet = EnemyBigJetNode()
        jet.name = "bigjet"
        jet.position = self.outsideWorld(jet, angle: genScreenAngle)

        let angle = normalizeAngle(position.angle)
        let sizeAngle = size.angle
        if angle > TAU - sizeAngle || angle <= sizeAngle {
            jet.position.y += ±spread
        }
        else if angle > TAU_2 + sizeAngle {
            jet.position.x += ±spread
        }
        else if angle > TAU_2 - sizeAngle {
            jet.position.y += ±spread
        }
        else {
            jet.position.x += ±spread
        }

        self << jet
    }

    func generateBigJetWithFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        let jet = EnemyBigJetNode()
        jet.name = "bigjet leader"
        jet.position = self.outsideWorld(jet, angle: genScreenAngle) + CGPoint(y: ±rand(spread))
        jet.rotateTowards(point: CGPointZero)
        self << jet

        let dist: CGFloat = 10
        var prevNode: Node = jet
        for i in 0..<10 {
            let location = jet.position + CGVector(r: dist * CGFloat(i), a: genScreenAngle)
            let enemy = EnemyJetNode(at: location)
            enemy.name = "bigjet follower"
            enemy.rotateTo(prevNode.zRotation)
            enemy.follow(prevNode, scatter: false, component: FollowTargetComponent())
            self << enemy
            prevNode = enemy
        }
    }

    func generateLeaderWithLinearFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
            screenAngle = screenAngle ± rand(spread)
        }
        let dist: CGFloat = 25
        let enemyLeader = EnemyLeaderNode()
        let leaderPosition = outsideWorld(enemyLeader, angle: screenAngle)
        enemyLeader.position = leaderPosition
        enemyLeader.rotateTowards(point: CGPointZero)
        enemyLeader.name = "linear leader"
        self << enemyLeader

        for i in 1...5 {
            let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: screenAngle)
            let enemy = EnemySoldierNode(at: location)
            enemy.name = "linear soldier"
            enemy.rotateTo(enemyLeader.zRotation)
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

    func generateLeaderWithCircularFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
            screenAngle = screenAngle ± rand(spread)
        }

        let ghost = generateEnemyGhost(angle: screenAngle, extra: 40)
        ghost.name = "circular ghost"
        ghost.rotateTowards(point: CGPointZero)

        let dist: CGFloat = 30
        var enemies: [Node] = []
        let enemyLeader = EnemyLeaderNode()
        enemyLeader.name = "circular leader"
        let leaderPosition = ghost.position + CGPoint(r: dist + enemyLeader.radius, a: screenAngle)
        enemyLeader.position = leaderPosition
        enemyLeader.rotateTo(ghost.zRotation)
        enemyLeader.follow(ghost)
        self << enemyLeader
        enemies << enemyLeader

        let count = 5
        let angleDelta = TAU / CGFloat(count)
        for i in 0..<count {
            let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 2)
            let vector = CGVector(r: dist, a: enemyAngle)
            let enemy = EnemySoldierNode(at: leaderPosition + vector)
            enemy.name = "circular soldier"
            enemy.rotateTo(ghost.zRotation)
            enemy.follow(ghost)
            self << enemy
            enemies << enemy
        }

       ghost.enemyComponent!.onTargetAcquired { target in
           if let target = target {
               for enemy in enemies {
                   enemy.rotateTowards(target)
               }
           }
       }
    }

    func generateGiant(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var screenAngle = genScreenAngle
        if spread > 0 {
           screenAngle = screenAngle ± rand(spread)
        }

        let enemyNode = EnemyGiantNode()
        enemyNode.name = "giant"
        enemyNode.position = outsideWorld(enemyNode, angle: screenAngle)
        self << enemyNode
    }

    func generateEnemyGhost(angle screenAngle: CGFloat, extra: CGFloat = 0) -> Node {
        let position = outsideWorld(extra: extra, angle: screenAngle)
        let enemyGhost = Node(at: position)
        let sprite = SKNode.size(EnemySoldierNode().size)
        enemyGhost << sprite
        enemyGhost.name = "ghost"
        let enemyComponent = EnemyComponent()
        enemyComponent.targetable = false
        enemyGhost.addComponent(enemyComponent)

        let rammingComponent = RammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.onRammed {
            enemyGhost.removeFromParent()
        }

        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(enemyComponent: enemyComponent)
        self << enemyGhost

        return enemyGhost
    }

}
