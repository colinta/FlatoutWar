////
///  LevelConfig.swift
//

class LevelConfig: Config {
    var trackExperience: Bool { return true }

    var possibleExperience: Int { return 0 }
    var gainedExperience: Int {
        get { return Defaults["\(configKey)-gainedExperience"].int ?? 0 }
        set { return Defaults["\(configKey)-gainedExperience"] = newValue }
    }
    var percentCompleted: CGFloat {
        guard possibleExperience > 0 else { return 0 }
        return min(CGFloat(gainedExperience) / CGFloat(possibleExperience), 1)
    }
    var levelCompleted: Bool {
        get { return Defaults.hasKey("\(configKey)-gainedExperience") }
        set {
            if !newValue {
                Defaults.remove("\(configKey)-gainedExperience")
            }
        }
    }
    var didSeeCutScene: Bool {
        get { return Defaults["\(configKey)-didSeeCutScene"].bool == true }
        set { Defaults["\(configKey)-didSeeCutScene"] = newValue }
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
        get { return Defaults["\(configKey)-seenTutorial"].bool ?? false }
        set { Defaults["\(configKey)-seenTutorial"] = newValue }
    }
    func tutorial() -> Tutorial? {
        return nil
    }

}
