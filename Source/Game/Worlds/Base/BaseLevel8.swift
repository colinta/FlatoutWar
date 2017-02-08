////
///  BaseLevel8.swift
//

class BaseLevel8: BaseLevel {
    override func loadConfig() -> LevelConfig { return BaseLevel8Config() }

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
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

}
