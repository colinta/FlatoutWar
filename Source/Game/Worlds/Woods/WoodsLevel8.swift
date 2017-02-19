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
            // director?.presentWorld(TutorialCutScene())
        }
    }

    override func populateLevel() {
        linkWaves(beginWave1)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
