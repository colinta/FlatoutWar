//
//  BaseLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel: Level {
    private var shouldPopulatePlayer = true
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
    var powerups: [Powerup] = []

    var cameraAngle: CGFloat?
    var cameraAdjustmentEnabled = false
    var cameraPosition: CGPoint?
    var cameraAdjustment: CGPoint = .zero {
        didSet {
            moveCamera(to: cameraPosition ?? .zero, duration: 0.5)
        }
    }

    override func moveCamera(from start: CGPoint? = nil, to target: CGPoint? = nil, zoom: CGFloat? = nil, duration: CGFloat? = nil, rate: CGFloat? = nil, handler: MoveToComponent.OnArrived? = nil) {
        var adjustedTarget: CGPoint?
        if let target = target {
            cameraPosition = target
            if cameraAdjustmentEnabled {
                adjustedTarget = target + cameraAdjustment
            }
        }
        super.moveCamera(to: adjustedTarget, from: start, zoom: zoom, duration: duration, rate: rate, handler: handler)
    }

    override func outsideWorld(extra dist: CGFloat, angle _angle: CGFloat, ui: Bool = false) -> CGPoint {
        let pt = super.outsideWorld(extra: dist, angle: _angle, ui: ui)
        if ui { return pt }

        let minDist = dist + min(size.height, size.width) / 2
        if playerNode.position.distanceTo(pt, within: minDist) {
            let a = playerNode.position.angleTo(pt)
            return playerNode.position + CGPoint(r: minDist, a: a)
        }
        return pt
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
        shouldPopulatePlayer = false
    }

    private func beginLevel(delay delay: Bool) {
        let zoomOut = {
            self.cameraAdjustmentEnabled = true
            self.cameraZoom.target = 1.0
            self.cameraZoom.rate = 0.5

            self.timeline.after(2, block: self.populateLevel)
        }

        if delay {
            timeline.after(1.75, block: zoomOut)
        }
        else {
            zoomOut()
        }

        let turrets = config.availableTurrets
        let buttonWidth: CGFloat = 45
        let x0: CGFloat = -CGFloat(turrets.count - 1) * buttonWidth / 2
        var buttons: [Node] = []
        for (index, turret) in turrets.enumerate() {
            let button = turret.button()
            buttons << button
            if index == 0 {
                button.setScale(1.1)
            }

            button.onTapped {
                self.playerNode.turret = turret
                for b in buttons {
                    b.setScale(1)
                }
                button.setScale(1.1)
            }

            let start: Position = .Bottom(
                x: x0 + CGFloat(index) * buttonWidth,
                y: -22
            )
            let dest: Position = .Bottom(
                x: start.x,
                y: 24
            )
            button.fixedPosition = start
            gameUI << button
            button.moveTo(dest, duration: 0.5)
        }
    }

    func populateLevel() {
    }

    override func populateWorld() {
        super.populateWorld()

        setScale(2)

        if shouldPopulatePlayer {
            updatePlayer(playerNode)
        }

        for node in config.storedPlayers {
            customizeNode(node)
        }

        timeline.when({ self.possibleExperience >= self.config.possibleExperience }) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }

        if config.canPowerup {
            beginPowerups()
        }
        beginLevel(delay: true)
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

    override func update(dt: CGFloat) {
        super.update(dt)
        for powerup in powerups {
            powerup.update(dt)
        }

        let isTouching = touchedNode?.touchableComponent?.isTouching ?? false
        if let angle = playerNode.rotateToComponent?.target
        where cameraAdjustmentEnabled && !isTouching
        {
            if angle != cameraAngle {
                cameraAdjustment = CGPoint(r: 20, a: angle)
                cameraAngle = angle
            }
        }
    }

}

extension BaseLevel {

    func beginPowerups() {
        let powerups = config.availablePowerups
        self.powerups = powerups
        for (index, powerup) in powerups.enumerate() {
            let start: Position = .Left(
                x: -150,
                y: 20 - CGFloat(index) * 80
            )
            let dest: Position = .TopLeft(
                x: 20,
                y: -20 - CGFloat(index) * 50
            )
            powerup.addToLevel(self, playerNode: playerNode, start: calculateFixedPosition(start), dest: dest)
        }
    }
}

extension BaseLevel {

    func tutorialOrLevel() -> World {
        if let tutorial = config.tutorial() where !tutorial.seen {
            tutorial.seen = true

            tutorial.nextWorld = self
            return tutorial
        }
        return self
    }


}

extension BaseLevel {

    override func levelCompleted(success successArg: Bool) {
        var success = successArg
        // sanity check against a kamikaze triggering a "successful" completion
        if let died = playerNode.healthComponent?.died where died {
            success = false
        }

        super.levelCompleted(success: success)

        for powerup in powerups {
            powerup.levelCompleted(success: success)
        }

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

            let totalText = TextNode(at: CGPoint(x: 100, y: 10))
            totalText.text = "\(possibleExperience)"
            totalText.font = .Big
            self << totalText

            let currentText = TextNode(at: CGPoint(x: 30, y: -30))
            currentText.text = "0"
            currentText.font = .Big
            self << currentText

            let maxCount = CGFloat(gainedExperience)
            var countEmUp: CGFloat = 0
            var countEmUpIncrement: CGFloat = 0.1
            let countEmUpRate: CGFloat = 0.03
            finalTimeline.every(countEmUpRate, start: 2, until: { countEmUp >= maxCount }) {
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

    func generateWarning(screenAngles: CGFloat...) {
        let innerRect = CGRect.zero
            .grow(by: size - CGSize(20))
        for screenAngle in screenAngles {
            let warning = Node()
            warning << SKSpriteNode(id: .Warning)
            warning.position = outsideWorld(extra: 0, angle: screenAngle, ui: true)
                .ensureInside(innerRect)
            warning.addComponent(JiggleComponent(timeout: nil))
            warning.fadeTo(1, start: 0, duration: 1)
            timeline.after(2) {
                warning.fadeTo(0, start: 1, duration: 1)
            }
            gameUI << warning
        }
    }

    func generateEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateSlowEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemySlowSoldierNode()
            enemyNode.name = "slow"
            enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    func generateLeaderEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemyLeaderNode()
            enemyNode.name = "leader"

            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateScouts(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            let d: CGFloat = 8
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            for i in 0..<3 {
                let enemyNode = EnemyScoutNode()
                enemyNode.name = "scout"
                let dp = CGPoint(r: CGFloat(i) * d, a: screenAngle)
                if constRadius {
                    enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle) + dp
                }
                else {
                    enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle) + dp
                }
                self << enemyNode
            }
        }
    }

    func generateJet(genScreenAngle: CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle)

            let angle = normalizeAngle(jet.position.angle)
            let sizeAngle = self.size.angle
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
    }

    func generateBigJet(genScreenAngle: CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle)

            let angle = normalizeAngle(jet.position.angle)
            let sizeAngle = self.size.angle
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
    }

    func generateBigJetWithFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet leader"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle) + CGPoint(y: ±rand(spread))
            jet.rotateTowards(point: .zero)
            self << jet

            let dist: CGFloat = 10
            var prevNode: Node = jet
            for i in 0..<10 {
                let location = jet.position + CGVector(r: dist * CGFloat(i), a: genScreenAngle)
                let enemy = EnemyJetNode(at: location)
                enemy.name = "bigjet follower"
                enemy.rotateTo(prevNode.zRotation)
                enemy.follow(prevNode, scatter: .None, component: FollowTargetComponent())
                self << enemy
                prevNode = enemy
            }
        }
    }

    func generateLeaderWithLinearFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            let leaderPosition = self.outsideWorld(enemyLeader, angle: screenAngle)
            enemyLeader.position = leaderPosition
            enemyLeader.rotateTowards(point: .zero)
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
    }

    func generateLeaderWithCircularFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }

            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 40)
            ghost.name = "circular ghost"
            ghost.rotateTowards(point: .zero)

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

           ghost.playerTargetingComponent!.onTargetAcquired { target in
               if let target = target {
                   for enemy in enemies {
                       enemy.rotateTowards(target)
                   }
               }
           }
        }
    }

    func generateGiant(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemyGiantNode()
            enemyNode.name = "giant"
            enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    func generateEnemyGhost(angle screenAngle: CGFloat, extra: CGFloat = 0) -> Node {
        let position = outsideWorld(extra: extra, angle: screenAngle)
        let enemyGhost = Node(at: position)
        let sprite = SKNode.size(EnemySoldierNode().size)
        enemyGhost << sprite
        enemyGhost.name = "ghost"
        let targetingComponent = PlayerTargetingComponent()
        enemyGhost.addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.onRammed { _ in
            enemyGhost.removeFromParent()
        }

        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        self << enemyGhost

        return enemyGhost
    }

}
