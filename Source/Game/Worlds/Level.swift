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
    let resumeButton = Button()
    let restartButton = Button()
    let backButton = Button()
    let nextButton = Button()
    let quitButton = Button()

    var possibleExperience = 0
    var gainedExperience = 0

    override var currentNode: Node? {
        if worldPaused {
            return pauseButton
        }
        return selectedNode ?? defaultNode
    }

    required init() {
        super.init()

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

        quitButton.fixedPosition = .Center(x: 0, y: 80)
        quitButton.visible = false
        quitButton.text = "QUIT"
        quitButton.font = .Big
        quitButton.onTapped {
            self.goToLevelSelect()
        }

        pauseButton.setScale(0.5)
        pauseButton.fixedPosition = .TopRight(x: -20, y: -20)
        pauseButton.text = "||"
        pauseButton.font = .Big
        pauseButton.size = CGSize(80)
        pauseButton.onTapped { _ in
            if self.worldPaused {
                self.unpause()
            }
            else {
                self.pause()
            }
        }

        backButton.fixedPosition = .Bottom(x: -27, y: 100)
        backButton.text = "<"
        backButton.style = .Square
        backButton.size = CGSize(50)
        backButton.visible = false
        backButton.font = .Big
        backButton.onTapped {
            self.goToLevelSelect()
        }

        nextButton.fixedPosition = .Bottom(x: 27, y: 100)
        nextButton.text = ">"
        nextButton.style = .Square
        nextButton.size = CGSize(50)
        nextButton.visible = false
        nextButton.font = .Big
        nextButton.onTapped(self.goToNextWorld)

        ui << resumeButton
        ui << restartButton
        ui << quitButton
        ui << pauseButton
        ui << backButton
        ui << nextButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func goToLevelSelect() {
        fatalError("goToLevelSelect should be overridden")
    }

    func goToNextWorld() {
        fatalError("goToNextWorld should be overridden")
    }

    enum Side {
        case Left
        case Right
        case Top
        case Bottom
    }

    func randSideAngle(sides: [Side]) -> CGFloat {
        return randSideAngle(sides.rand())
    }

    func randSideAngle(side: Side? = nil) -> CGFloat {
        if let side = side {
            let spread: CGFloat
            switch side {
            case .Left, .Right:
                spread = atan2(size.height, size.width)
            case .Top, .Bottom:
                spread = atan2(size.width, size.height)
            }

            let angle: CGFloat
            switch side {
            case .Right:
                angle = 0
            case .Top:
                angle = TAU_4
            case .Left:
                angle = TAU_2
            case .Bottom:
                angle = TAU_3_4
            }

            return angle ± rand(spread)
        }
        else {
            return randSideAngle(rand() ? .Left : .Right)
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

    override func didAdd(node: Node) {
        if let healthComponent = node.healthComponent,
            enemyComponent = node.enemyComponent
        {
            let exp = enemyComponent.experience
            addToPossibleExperience(exp)
            healthComponent.onKilled { self.addToGainedExperience(exp) }
        }
        super.didAdd(node)
    }

    func addToPossibleExperience(exp: Int) {
        possibleExperience += exp
    }

    func addToGainedExperience(exp: Int) {
        gainedExperience += exp
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

    var levelSuccess: Bool?
    func levelCompleted(success success: Bool) {
        printStatus()
        guard levelSuccess == nil else {
            return
        }
        levelSuccess = success

        defaultNode = nil
        selectedNode = nil

        timeline.removeFromNode()
        pauseButton.removeFromParent()

        for node in gameUI.children {
            if let node = node as? Button {
                node.enabled = false
            }
        }

        moveCamera(to: .zero, zoom: 2, duration: 1)
    }

}
