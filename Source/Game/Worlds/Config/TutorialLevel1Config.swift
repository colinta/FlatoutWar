////
///  TutorialLevel1Config.swift
//

class TutorialLevel1Config: TutorialConfig {
    override var availableTurrets: [Turret] { return [] }

    override var possibleExperience: Int { return 100 }

    override func tutorial() -> Tutorial? { return AutoFireTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel2()
    }

}
