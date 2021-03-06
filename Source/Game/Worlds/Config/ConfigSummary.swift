////
///  ConfigSummary.swift
//

class ConfigSummary: Config {
    var configs: [LevelConfig]

    override init() {
        configs = []
        super.init()
    }

    var percentCompleted: CGFloat {
        let complete = configs.reduce(CGFloat(0)) { memo, c in
            return memo + c.percentCompleted
        }
        return complete / CGFloat(configs.count)
    }

    var totalGainedExperience: Int {
        return configs.map { $0.gainedExperience }.reduce(0, +)
    }

    var worldCompleted: Bool {
        return configs.all { $0.levelCompleted }
    }

    func completeAll() {
        for c in configs {
            c.levelCompleted = true
        }
    }

    func resetAll() {
        for c in configs {
            c.seenTutorial = false
            c.levelCompleted = false
        }
    }
}
