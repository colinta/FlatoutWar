//
//  Level.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/4/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let debug = false

class Level: World {
    let pauseButton = PauseButton()
    let resumeButton = ButtonNode()
    let restartButton = ButtonNode()
    let backButton = ButtonNode()
    let nextButton = ButtonNode()
    let quitButton = ButtonNode()

    var possibleExperience = 0
    var gainedExperience = 0

    override var currentNode: Node? {
        if worldPaused {
            return pauseButton
        }
        return selectedNode ?? defaultNode
    }

    let startupZoomingComponent = ZoomToComponent()

    required init() {
        super.init()

        resumeButton.fixedPosition = .C(x: 0, y: 0)
        resumeButton.visible = false
        resumeButton.text = "RESUME"
        resumeButton.onTapped {
            self.unpause()
        }

        restartButton.fixedPosition = .C(x: 0, y: -80)
        restartButton.visible = false
        restartButton.text = "RESTART"
        restartButton.onTapped {
            self.restartWorld()
        }

        quitButton.fixedPosition = .C(x: 0, y: 80)
        quitButton.visible = false
        quitButton.text = "QUIT"
        quitButton.onTapped {
            self.director?.presentWorld(LevelSelectWorld())
        }

        pauseButton.setScale(0.5)
        pauseButton.fixedPosition = .TR(x: -20, y: -20)
        pauseButton.text = "||"
        pauseButton.size = CGSize(80)
        pauseButton.onTapped { _ in
            if self.worldPaused {
                self.unpause()
            }
            else {
                self.pause()
            }
        }

        backButton.fixedPosition = .C(x: -27, y: -80)
        backButton.text = "<"
        backButton.style = .Square
        backButton.size = CGSize(50)
        backButton.visible = false
        backButton.onTapped {
            self.director?.presentWorld(LevelSelectWorld())
        }

        nextButton.fixedPosition = .C(x: 27, y: -80)
        nextButton.text = ">"
        nextButton.style = .Square
        nextButton.size = CGSize(50)
        nextButton.visible = false
        nextButton.onTapped(self.goToNextWorld)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func goToNextWorld() {
        fatalError("goToNextWorld should be overridden")
    }

    func randSideAngle() -> CGFloat {
        let angle: CGFloat = rand(size.angle * 2 / 3)
        return (rand() ? TAU_2 : 0) ± angle
    }

    override func onPause() {
        resumeButton.visible = true
        restartButton.visible = true
        quitButton.visible = true
    }

    override func onUnpause() {
        if !worldPaused {
            resumeButton.visible = false
            restartButton.visible = false
            quitButton.visible = false
        }
    }

    override func populateWorld() {
        super.populateWorld()

        ui << resumeButton
        ui << restartButton
        ui << quitButton
        ui << pauseButton
        ui << backButton
        ui << nextButton

        setScale(2)
        startupZoomingComponent.rate = 0.5
        startupZoomingComponent.target = 1.0
        timeline.at(1.75) { self.addComponent(self.startupZoomingComponent) }
    }

    override func willAdd(node: Node) {
        if let healthComponent = node.healthComponent,
            enemyComponent = node.enemyComponent
        {
            let exp = enemyComponent.experience
            addToPossibleExperience(exp)
            healthComponent.onKilled { self.addToGainedExperience(exp) }
        }
        super.willAdd(node)
    }

    func addToPossibleExperience(exp: Int) {
        possibleExperience += exp
    }

    func addToGainedExperience(exp: Int) {
        gainedExperience += exp
    }

    override func worldShook() {
        print("at time \(timeline.time)")
        print("possibleExperience: \(possibleExperience)")
        print("resetting keys")
    }

    override func update(dt: CGFloat) {
        super.update(dt)
    }

    var levelSuccess: Bool?
    func levelCompleted(success success: Bool) {
        guard levelSuccess == nil else {
            return
        }
        levelSuccess = success

        defaultNode = nil
        selectedNode = nil

        timeline.removeFromNode()
        pauseButton.removeFromParent()

        startupZoomingComponent.rate = 1.0
        startupZoomingComponent.target = 2.0
    }

    func restartWorld() {
        director?.presentWorld(self.dynamicType.init())
    }

}
