////
///  UpgradeConfigSummary.swift
//

class UpgradeConfigSummary: Config {
    var configs: [ConfigSummary] = [
        TutorialConfigSummary(),
        BaseConfigSummary(),
    ]

    var totalGainedExperience: Int {
        return configs.map { $0.totalGainedExperience }.reduce(0, combine: +)
    }
    var spentExperience: Int {
        get { return Defaults["\(configKey)-spentExperience"].int ?? 0 }
    }
    var availableExperience: Int {
        return totalGainedExperience - spentExperience
    }

    var totalGainedResources: Int {
        return configs.map { $0.totalGainedResources }.reduce(0, combine: +)
    }
    var spentResources: Int {
        get { return Defaults["\(configKey)-spentResources"].int ?? 0 }
    }
    var availableResources: Int {
        return totalGainedResources - spentResources
    }

    func canAfford(experience experience: Int = 0, resources: Int = 0) -> Bool {
        return availableExperience - experience >= 0 && availableResources - resources >= 0
    }

    func spent(experience experience: Int = 0, resources: Int = 0) {
        if experience > 0 {
            Defaults["\(configKey)-spentExperience"] = spentExperience + experience
        }
        if resources > 0 {
            Defaults["\(configKey)-spentResources"] = spentResources + resources
        }
    }

}
