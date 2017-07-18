////
///  OceanLevel3.swift
//

// Starts with dozers with 8 scouts behind them, and some slow soldiers
// to throw at the drone.  The second wave is a series of large scale attacks
// from slow soldiers, normal soldiers, and scouts, using the 'flying' ramming
// behavior (they move towards arbitrary midpoints before seeking the target).
// The level ends with normal soldiers attacking in wide waves.
//
// The level goes to a cut scene that introduces the upgraded dodec drone.

class OceanLevel3: OceanLevel {
    override func loadConfig() -> LevelConfig { return OceanLevel3Config() }

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
            director?.presentWorld(OceanLevel3CutScene())
        }
    }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    func beginWave1(nextStep: @escaping NextStepBlock) {
    }

    func beginWave2(nextStep: @escaping NextStepBlock) {
    }

    func beginWave3(nextStep: @escaping NextStepBlock) {
    }

}
