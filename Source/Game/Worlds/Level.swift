////
///  Level.swift
//

import AVFoundation


class Level: World {
    fileprivate var _config: LevelConfig?
    var config: LevelConfig {
        if let config = _config {
            return config
        }
        let config = loadConfig()
        _config = config
        return config
    }
    func loadConfig() -> LevelConfig {
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
    var shouldAutoZoomOut = true
    var levelSuccess: Bool?
    var playerDeadAudio: BackgroundAudioNode?

    var experiencePercent: ExperiencePercent?
    fileprivate var possibleExperience = 0
    fileprivate var gainedExperience = 0

    fileprivate var shouldPopulatePlayer = true
    var playerNode: Node = BasePlayerNode() {
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

    override var currentNode: Node? {
        if worldPaused {
            return pauseButton
        }
        return super.currentNode
    }

    required init() {
        levelSelect = .select
        super.init()
        pauseable = true
        multitouchEnabled = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func populateWorld() {
        super.populateWorld()

        if let playerDeadAudio = BackgroundAudioNode(name: "dead") {
            playerDeadAudio.deltaVolume = 0.2
            self << playerDeadAudio
            self.playerDeadAudio = playerDeadAudio
        }

        setScale(2)
        cameraZoom.duration = nil
        cameraZoom.rate = nil

        fadeTo(1, start: 0, duration: 0.5)
        if shouldAutoZoomOut {
            timeline.after(time: 1.75, block: self.populateZoomOut)
        }

        populateUI()
        populatePlayerNodes()
        populatePowerups()
    }

    func populateZoomOut() {
        cameraZoom.target = 1.0
        cameraZoom.rate = 0.5

        timeline.after(time: 2, block: populateLevel)
    }

    func populateLevel() {
    }

    override func update(_ dt: CGFloat) {
        super.update(dt)
        for powerup in powerups {
            powerup.update(dt)
        }
    }

    override func onHalt() {
        super.onHalt()
        playerDeadAudio?.pause()
    }

    override func onPause() {
        super.onPause()
        if levelSuccess == nil {
            resumeButton.visible = true
            restartButton.visible = true
            quitButton.visible = true
        }
    }

    override func onResume() {
        super.onResume()
        playerDeadAudio?.resume()
    }

    override func onUnpause() {
        if !worldPaused {
            quitButton.visible = false
            restartButton.visible = false
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

    override func didAdd(_ node: Node) {
        super.didAdd(node)
        if let enemyComponent = node.enemyComponent,
            let healthComponent = node.healthComponent
        {
            addToPossibleExperience(enemyComponent.experience)
            healthComponent.onKilled {
                self.experiencePercent?.gain(enemyComponent.experience)
                self.addToGainedExperience(enemyComponent.experience)
            }
        }
    }

    override func outsideWorld(extra dist: CGFloat, angle: CGFloat, ui: Bool = false) -> CGPoint {
        let pt = super.outsideWorld(extra: dist, angle: angle, ui: ui)
        if ui { return pt }

        let minDist = dist + min(size.height, size.width) / 2
        let center = playerNode.position
        if center.distanceTo(pt, within: minDist) {
            let a = center.angleTo(pt)
            return center + CGPoint(r: minDist, a: a)
        }
        return pt
    }

    func addToPossibleExperience(_ exp: Int) {
        possibleExperience += exp
    }

    func addToGainedExperience(_ exp: Int) {
        gainedExperience += exp
    }

    fileprivate func populateUI() {
        if config.trackExperience && config.possibleExperience > 0 {
            experiencePercent = ExperiencePercent(goal: config.possibleExperience)
            ui << experiencePercent!
        }

        pauseButton.onTapped {
            if self.worldPaused {
                self.unpause()
            }
            else {
                self.pause()
            }
        }

        quitButton.fixedPosition = .center(x: 0, y: 80)
        quitButton.visible = false
        quitButton.text = "QUIT"
        quitButton.font = .big
        quitButton.onTapped {
            self.goToLevelSelect()
        }

        resumeButton.fixedPosition = .center(x: 0, y: -80)
        resumeButton.visible = false
        resumeButton.text = "RESUME"
        resumeButton.font = .big
        resumeButton.onTapped {
            self.unpause()
        }

        restartButton.fixedPosition = .center(x: 0, y: 0)
        restartButton.visible = false
        restartButton.text = "RESTART"
        restartButton.font = .big
        restartButton.onTapped {
            self.restartWorld()
        }

        backButton.fixedPosition = .top(x: -60, y: -60)
        backButton.style = .rectSized(110, 60)
        backButton.text = "BACK"
        backButton.visible = false
        backButton.font = .big
        backButton.onTapped {
            self.goBackToLevelSelect()
        }

        nextButton.fixedPosition = .top(x: 60, y: -60)
        nextButton.style = .rectSized(110, 60)
        nextButton.text = "NEXT"
        nextButton.visible = false
        nextButton.font = .big
        nextButton.onTapped(self.goToNextWorld)

        ui << pauseButton
        ui << quitButton
        ui << resumeButton
        ui << restartButton
        ui << backButton
        ui << nextButton
    }

    fileprivate func populatePlayerNodes() {
        for node in config.availableArmyNodes() {
            addArmyNode(node)
        }

        if shouldPopulatePlayer {
            updatePlayer(playerNode)
        }
    }

    fileprivate func populatePowerups() {
        let powerups = config.availablePowerups()
        self.powerups = powerups
        for (index, powerup) in powerups.enumerated() {
            let start: Position = .left(
                x: -150,
                y: 20 - CGFloat(index) * 80
            )
            let dest: Position = .topLeft(
                x: 20,
                y: -20 - CGFloat(index) * 50
            )
            powerup.addToLevel(self, playerNode: playerNode, start: calculateFixedPosition(start), dest: dest)
        }
    }

    fileprivate func updatePlayer(_ node: Node) {
        node.healthComponent?.onKilled {
            if self.playerNode == node {
                self.completeLevel(success: false)
            }
        }

        self << playerNode
        defaultNode = playerNode

        shouldPopulatePlayer = false
    }

    func goBackToLevelSelect() {
        goToLevelSelect()
    }

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
        if !config.seenTutorial, let tutorial = config.tutorial() {
            tutorial.nextWorld = self
            return tutorial
        }
        return self
    }

    func completeLevel(success successArg: Bool? = nil) {
        guard levelSuccess == nil else {
            return
        }

        printStatus()
        for powerup in powerups {
            powerup.levelCompleted()
        }

        let success: Bool
        // sanity check against a kamikaze killing the player *and* triggering a
        // "successful" completion
        if let died = playerNode.healthComponent?.died, died {
            success = false
        }
        else if let successArg = successArg {
            success = successArg
        }
        else {
            success = true
        }

        pauseable = false
        levelSuccess = success

        defaultNode = nil
        selectedNode = nil
        timeRate = 1

        for node in allChildNodes(recursive: true) {
            node.levelCompleted()
        }
        self.levelCompleted()

        timeline.removeFromNode()
        pauseButton.removeFromParent()

        for node in gameUI.children {
            if let node = node as? Button {
                node.enabled = false
            }
        }

        moveCamera(to: .zero, zoom: 2, duration: 1)

        for node in players + enemies {
            node.active = false
        }

        if success {
            let finalTimeline = TimelineComponent()
            addComponent(finalTimeline)

            config.updateMaxGainedExperience(gainedExperience)

            let percentNode = PercentBar(at: CGPoint(x: 60, y: 0))
            self << percentNode

            let currentText = TextNode(at: CGPoint(x: 30, y: 30))
            currentText.text = "0%"
            currentText.font = .small
            self << currentText

            let gained = CGFloat(gainedExperience)
            let possible = CGFloat(config.possibleExperience)

            let earnedPercent: CGFloat = min(1, gained / possible)
            var countEmUp: CGFloat = 0
            var countEmUpIncrement: CGFloat = 0.025
            let countEmUpRate: CGFloat = 0.03
            finalTimeline.every(countEmUpRate, start: 2, until: { countEmUp >= earnedPercent }) {
                countEmUp = min(countEmUp + countEmUpIncrement, earnedPercent)
                countEmUpIncrement *= 1.05

                percentNode.complete = countEmUp
                currentText.text = "\(Int(round(countEmUp * 1000)) / 10)%"
                currentText.position.x = CGFloat(30) + percentNode.complete * percentNode.size.width
            }

            finalTimeline.when({ countEmUp >= earnedPercent }) {
                currentText.text = "\(Int(round(earnedPercent * 1000) / 10))%"

                if earnedPercent == 1 {
                    finalTimeline.every(1) {
                        let explosion = EnemyExplosionNode(at: CGPoint(x: ±rand(self.size.width / 4), y: ±rand(self.size.height / 4)))
                        self << explosion
                    }
                }

                self.restartButton.fixedPosition = .bottom(x: 0, y: 80)
                if self.shouldReturnToLevelSelect {
                    self.backButton.fixedPosition = .top(x: 0, y: -60)
                }
                self.showFinalButtons()
            }
        }
        else {
            playerDeadAudio?.play()

            let playerCenter = playerNode.position
            playerNode.removeFromParent()
            let explosion = PlayerExplosionNode()
            explosion.position = playerCenter
            self << explosion

            quitButton.visible = true
            restartButton.visible = true
        }
    }

    func showCutSceneButtons() {
        quitButton.visible = false
        restartButton.visible = false
        nextButton.fixedPosition = .center(x: 0, y: -60)
        nextButton.visible = true
    }

    func showFinalButtons() {
        restartButton.visible = true
        backButton.visible = true

        if shouldReturnToLevelSelect {
            backButton.text = "NEXT"
        }
        else {
            nextButton.visible = true
        }
    }

    func addArmyNode(_ node: Node) {
        if node is BasePlayerNode {
            fatalError("player node should not be added in this way")
        }
        else {
            if let draggableComponent = node.draggableComponent {
                draggableComponent.maintainDistance(120, around: playerNode)
            }

            node.fadeTo(1, start: 0, duration: 1.4)
            self << node
        }
    }

    func linkWaves(_ waves: ((@escaping NextStepBlock) -> Void)...) {
        guard let beginWave1 = waves.first else { return }

        var nextStep = afterAllWaves(nextWave: { self.completeLevel() })
        if waves.count > 1 {
            for wave in waves[1..<waves.count].reversed() {
                let prevStep = nextStep
                nextStep = afterAllWaves(nextWave: {
                    self.printStatus()
                    wave(prevStep)
                })
            }
        }
        beginWave1(nextStep)
    }
}
