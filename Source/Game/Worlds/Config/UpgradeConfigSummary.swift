////
///  UpgradeConfigSummary.swift
//

class UpgradeConfigSummary: Config {
    var configs: [ConfigSummary] = [
        TutorialConfigSummary(),
        BaseConfigSummary(),
    ]

    private var totalGainedExperience: Int {
        return configs.map { $0.totalGainedExperience }.reduce(0, +)
    }
    var spentExperience: Int {
        get { return Defaults["\(configKey)-spentExperience"].int ?? 0 }
        set { return Defaults["\(configKey)-spentExperience"] = newValue }
    }
    var availableExperience: Int {
        return totalGainedExperience - spentExperience
    }

    private var totalGainedResources: Int {
        return configs.map { $0.totalGainedResources }.reduce(0, +)
    }
    var spentResources: Int {
        get { return Defaults["\(configKey)-spentResources"].int ?? 0 }
        set { return Defaults["\(configKey)-spentResources"] = newValue }
    }
    var availableResources: Int {
        return totalGainedResources - spentResources
    }

    func canAfford(_ amount: Currency) -> Bool {
        return availableExperience - amount.experience >= 0 && availableResources - amount.resources >= 0
    }

    func spent(_ amount: Currency) {
        if amount.experience > 0 {
            spentExperience += amount.experience
        }
        if amount.resources > 0 {
            spentResources += amount.resources
        }
    }

}
