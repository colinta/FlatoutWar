////
///  TutorialLevel4.swift
//

class TutorialLevel4: TutorialLevel {
    override func loadConfig() -> LevelConfig { return TutorialLevel4Config() }

    override func populateLevel() {
        linkWaves(beginWave1, beginWave2, beginWave3)
    }

    func beginWave1(nextStep: NextStepBlock) {
    }

    func beginWave2(nextStep: NextStepBlock) {
    }

    func beginWave3(nextStep: NextStepBlock) {
    }

}
