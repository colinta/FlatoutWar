//
//  Level.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/4/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Level: World {
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
        fatalError("loadConfig() has not been implemented")
    }

    let pauseButton = PauseButton()
    let quitButton = Button()
    let resumeButton = Button()
    let restartButton = Button()
    let backButton = Button()
    let nextButton = Button()

    var levelSelect: WorldSelectWorld.LevelId
    var shouldReturnToLevelSelect = false
    var levelSuccess: Bool?

    var experiencePercent: ExperiencePercent?
    var resourcePercent: ResourcePercent?
    var possibleExperience = 0
    var gainedExperience = 0

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
    var powerups: [Powerup] = []

    var cameraAngle: CGFloat?
    var cameraAdjustmentEnabled = false
    var cameraPosition: CGPoint?
    var cameraAdjustment: CGPoint = .zero {
        didSet {
            moveCamera(to: cameraPosition ?? .zero, duration: 0.5)
        }
    }

    override var currentNode: Node? {
        if worldPaused {
            return pauseButton
        }
        return super.currentNode
    }

    required init() {
        levelSelect = .Select
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func populateWorld() {
        super.populateWorld()

        setScale(2)
        fadeTo(1, start: 0, duration: 0.5)
        timeline.after(1.75, block: {
            self.cameraAdjustmentEnabled = true
            self.cameraZoom.target = 1.0
            self.cameraZoom.rate = 0.5

            self.timeline.after(2, block: self.populateLevel)
        })

        populateUI()
        populatePlayerNodes()
        populateTurrets()
        if config.canPowerup {
            populatePowerups()
        }

        timeline.when({ self.possibleExperience >= self.config.possibleExperience }) {
            self.onNoMoreEnemies {
                self.levelCompleted(success: true)
            }
        }
    }

    override func update(dt: CGFloat) {
        super.update(dt)
        for powerup in powerups {
            powerup.update(dt)
        }

        if let angle = playerNode.rotateToComponent?.target
        where cameraAdjustmentEnabled
        {
            if angle != cameraAngle {
                cameraAdjustment = CGPoint(r: 20, a: angle)
                cameraAngle = angle
            }
        }
    }

    override func onPause() {
        resumeButton.visible = true
        quitButton.visible = true
    }

    override func onUnpause() {
        if !worldPaused {
            quitButton.visible = false
            resumeButton.visible = false
        }
    }

    override func worldShook() {
        super.worldShook()
        // if timeRate == 0.5 { timeRate = 3 }
        // else if timeRate == 3 { timeRate = 1 }
        // else { timeRate = 0.5 }
        printStatus()
    }

    func printStatus() {
        print("timeRate: \(timeRate)")
        print("possibleExperience: \(possibleExperience)")
        print("gainedExperience: \(gainedExperience)")
    }

    override func didAdd(node: Node) {
        super.didAdd(node)
        if let enemyComponent = node.enemyComponent,
            healthComponent = node.healthComponent
        {
            let exp = enemyComponent.experience
            addToPossibleExperience(exp)
            healthComponent.onKilled {
                self.experiencePercent?.gain(enemyComponent.experience)
                self.addToGainedExperience(exp)
            }
        }
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
}

extension Level {
    func addToPossibleExperience(exp: Int) {
        possibleExperience += exp
    }

    func addToGainedExperience(exp: Int) {
        gainedExperience += exp
    }
}

extension Level {
    func populateLevel() {
    }

    private func populateUI() {
        if config.trackExperience {
            experiencePercent = ExperiencePercent(goal: config.requiredExperience)
            ui << experiencePercent!
        }

        if config.trackResources {
            resourcePercent = ResourcePercent(goal: config.requiredResources)
            ui << resourcePercent!
        }

        pauseButton.onTapped { _ in
            if self.worldPaused {
                self.unpause()
            }
            else {
                self.pause()
            }
        }

        quitButton.fixedPosition = .Center(x: 0, y: 80)
        quitButton.visible = false
        quitButton.text = "QUIT"
        quitButton.font = .Big
        quitButton.onTapped {
            self.goToLevelSelect()
        }

        resumeButton.fixedPosition = .Center(x: 0, y: -80)
        resumeButton.visible = false
        resumeButton.text = "RESUME"
        resumeButton.font = .Big
        resumeButton.onTapped {
            self.unpause()
        }

        restartButton.fixedPosition = .Center(x: 0, y: -80)
        restartButton.visible = false
        restartButton.text = "RESTART"
        restartButton.font = .Big
        restartButton.onTapped {
            self.restartWorld()
        }

        backButton.fixedPosition = .Top(x: -20, y: 80)
        backButton.text = "BACK"
        backButton.visible = false
        backButton.font = .Big
        backButton.onTapped {
            self.goToLevelSelect()
        }

        nextButton.fixedPosition = .Top(x: 20, y: 80)
        nextButton.text = "NEXT"
        nextButton.visible = false
        nextButton.font = .Big
        nextButton.onTapped(self.goToNextWorld)

        ui << pauseButton
        ui << quitButton
        ui << resumeButton
        ui << restartButton
        ui << backButton
        ui << nextButton
    }

    private func populatePlayerNodes() {
        for node in config.storedPlayers {
            if let playerNode = node as? BasePlayerNode {
                self.playerNode = playerNode
            }
        }

        if shouldPopulatePlayer {
            updatePlayer(playerNode)
        }

        for node in players where node != playerNode {
            customizeNode(node)
        }
    }

    private func populateTurrets() {
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

    private func populatePowerups() {
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

extension Level {
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
}

extension Level {
    func goToLevelSelect() {
        director?.presentWorld(WorldSelectWorld(beginAt: levelSelect))
    }

    func goToNextWorld() {
        if shouldReturnToLevelSelect {
            goToLevelSelect()
        }
        else {
            let nextLevel = config.nextLevel()
            self.director?.presentWorld(nextLevel.tutorialOrLevel())
        }
    }

    func tutorialOrLevel() -> World {
        if let tutorial = config.tutorial() where !config.seenTutorial {
            config.seenTutorial = true
            tutorial.nextWorld = self
            return tutorial
        }
        return self
    }

    func levelCompleted(success successArg: Bool) {
        for powerup in powerups {
            powerup.levelCompleted()
        }

        var success = successArg
        // sanity check against a kamikaze triggering a "successful" completion
        if let died = playerNode.healthComponent?.died where died {
            success = false
        }

        printStatus()
        guard levelSuccess == nil else {
            return
        }
        levelSuccess = success

        defaultNode = nil
        selectedNode = nil
        timeRate = 1

        timeline.removeFromNode()
        pauseButton.removeFromParent()

        for node in gameUI.children {
            if let node = node as? Button {
                node.enabled = false
            }
        }

        moveCamera(to: .zero, zoom: 2, duration: 1)

        let finalTimeline = TimelineComponent()
        addComponent(finalTimeline)

        for node in players + enemies {
            node.active = false
        }

        if success {
            config.updateMaxGainedExperience(gainedExperience)
            config.nextLevel().config.storedPlayers = self.players

            let percentNode = PercentBar(at: CGPoint(x: 60, y: 0))
            self << percentNode

            let currentText = TextNode(at: CGPoint(x: 30, y: 30))
            currentText.text = "0%"
            currentText.font = .Small
            self << currentText

            let maxCount = CGFloat(gainedExperience / possibleExperience)
            var countEmUp: CGFloat = 0
            var countEmUpIncrement: CGFloat = 0.025
            let countEmUpRate: CGFloat = 0.03
            finalTimeline.every(countEmUpRate, start: 2, until: { countEmUp >= maxCount }) {
                countEmUp = min(countEmUp + countEmUpIncrement, maxCount)
                countEmUpIncrement *= 1.05

                percentNode.complete = countEmUp
                currentText.text = "\(Int(round(countEmUp * 1000)) / 10)%"
                currentText.position.x = CGFloat(30) + percentNode.complete * percentNode.size.width
            }

            finalTimeline.when({ countEmUp >= maxCount }) {
                currentText.text = "\(Int(round(maxCount * 100)))%"

                self.restartButton.visible = true
                self.backButton.visible = true

                if self.shouldReturnToLevelSelect {
                    self.backButton.fixedPosition = .Top(x: 0, y: 80)
                }
                else {
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

extension Level {
    func introduceDrone() {
        let drone = DroneNode()
        drone.position = CGPoint(-30, -60)
        customizeNode(drone)
    }

    func customizeNode(node: Node) {
        if node is BasePlayerNode {
            fatalError("player node should not be customized in this way")
        }
        else {
            if let _ = node as? DroneNode {
            }

            node.fadeTo(1, start: 0, duration: 1.4)
            node.draggableComponent?.maintainDistance(100, around: playerNode)
            self << node
        }
    }
}

extension Level: ResourceWorld {
    func playerFoundResource(resourceNode: ResourceNode) {
        resourceNode.locked = true
        resourceNode.disableMovingComponents()

        let resourcePoint = playerNode.convertPosition(resourceNode)
        let resourceLine = SKSpriteNode()
        resourceLine.anchorPoint = CGPoint(0, 0.5)
        resourceLine.z = .BelowPlayer
        resourceLine.position = self.playerNode.position
        resourceLine.textureId(.ResourceLine(length: resourcePoint.length))
        resourceLine.zRotation = resourcePoint.angle
        self << resourceLine

        let resourceCollector = ResourceCollector(resource: resourceNode)
        resourceCollector.resourceLine = resourceLine
        resourceCollector.position = playerNode.position

        resourceCollector.onHarvest { harvested in
            self.resourcePercent?.gain(harvested)
        }
        self << resourceCollector
    }
}
