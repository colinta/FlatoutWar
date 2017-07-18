////
///  OceanLevel8.swift
//

class OceanLevel8: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel8Config() }

    override func showFinalButtons() {
        if config.didSeeCutScene {
            super.showFinalButtons()
        }
        else {
            showCutSceneButtons()
        }
    }

    override func goToNextWorld() {
        if config.didSeeCutScene {
            super.goToNextWorld()
        }
        else {
            config.didSeeCutScene = true
            director?.presentWorld(OceanLevel8CutScene())
        }
    }

    override func populateLevel() {
        linkWaves(beginWave2)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: -50), zoom: 0.7, duration: 1)
        generateSideWarnings(side: .Right)
        let angle1 = rand(10.degrees) as CGFloat
        let angle2 = angle1 ± rand(min: 10.degrees, max: 20.degrees)
        let angle3 = angle2 ± rand(min: 10.degrees, max: 20.degrees)
        timeline.at(.Delayed(3)) {
            self.generateDozer(angle1)()
            self.generateGiant(angle1)()
        } ~~> nextStep()

        timeline.at(.Delayed(8)) {
            self.generateDozer(angle2)()
            self.generateGiant(angle2)()
        } ~~> nextStep()

        timeline.at(.Delayed(9)) {
            self.generateDozer(angle3)()
            self.generateGiant(angle3)()
        } ~~> nextStep()
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
        moveCamera(to: CGPoint(x: -600), zoom: 2, duration: 3)
        self.timeline.after(time: 8) {
            self.moveCamera(to: CGPoint(x: -50), zoom: 0.7, duration: 1)
        }

        let boss1 = WoodsBossNode(at: CGPoint(x: -550))
        self << boss1

        let boss2 = WoodsBossNode(at: CGPoint(y: size.height + 1 * boss1.size.width))
        boss2.zRotation = -TAU_2
        self << boss2

        nextStep()()
    }

}
