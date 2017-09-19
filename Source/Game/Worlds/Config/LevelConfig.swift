////
///  LevelConfig.swift
//

class LevelConfig: Config {
    var trackExperience: Bool { return true }

    var possibleExperience: Int { return 0 }
    var gainedExperience: Int {
        get { return defaults("gainedExperience").int ?? 0 }
        set { return defaults("gainedExperience", set: newValue) }
    }
    var percentCompleted: CGFloat {
        guard possibleExperience > 0 else { return 0 }
        return min(CGFloat(gainedExperience) / CGFloat(possibleExperience), 1)
    }
    var levelCompleted: Bool {
        get { return defaults(has: "gainedExperience") }
        set {
            if !newValue {
                defaults(remove: "gainedExperience")
            }
        }
    }
    var didSeeCutScene: Bool {
        get { return defaults("didSeeCutScene").bool == true }
        set { defaults("didSeeCutScene", set: newValue) }
    }

    func availableArmyNodes() -> [Node] { return [] }
    func availablePowerups() -> [Powerup] { return [] }

    func updateMaxGainedExperience(_ exp: Int) {
        gainedExperience = min(max(exp, gainedExperience), possibleExperience)
    }

    func nextLevel() -> Level {
        fatalError("nextLevel() has not been implemented by \(type(of: self))")
    }

    var hasTutorial: Bool { return tutorial() != nil }
    var seenTutorial: Bool {
        get { return defaults("seenTutorial").bool ?? false }
        set { defaults("seenTutorial", set: newValue) }
    }
    func tutorial() -> Tutorial? {
        return nil
    }

}
