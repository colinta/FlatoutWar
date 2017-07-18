////
///  WoodsLevel8.swift
//

class WoodsLevel8: WoodsLevel {
    override func loadConfig() -> LevelConfig { return WoodsLevel8Config() }

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
            director?.presentWorld(WoodsLevel8CutScene())
        }
    }

    override func populateLevel() {
        let points = [
            CGPoint(-1.2, -1), CGPoint(-1, -1.2),
            CGPoint(-2, -0.8), CGPoint(-1.5, -0.85),
            CGPoint(-1.75, -0.7), CGPoint(-1.25, -0.6),
            CGPoint(-1.25, -0.4), CGPoint(-1.5, -0.2),
            CGPoint(-2, 0.5), CGPoint(-1.75, 0.6),
            CGPoint(-1.75, 0.7), CGPoint(-1.8, 0.7),
            CGPoint(-1.8, 0.9), CGPoint(-1.2, 1.1),
        ]
        let dr: CGFloat = 0.1
        for p in points {
            let info = TreeInfo(center: p + CGPoint(r: dr, a: rand(TAU)))
            self << generateTree(info: info)
        }
        linkWaves(beginWave1, beginWave2)
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
