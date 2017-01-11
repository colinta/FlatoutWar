////
///  TutorialLevel2Config.swift
//

class TutorialLevel2Config: TutorialConfig {
    override var possibleExperience: Int { return 110 }

    override func tutorial() -> Tutorial? { return nil }
    override func nextLevel() -> Level {
        return TutorialLevel3()
    }
}
