////
///  UpgradeConfigSummary.swift
//

class UpgradeConfigSummary: Config {
    var configs: [ConfigSummary] = [
        TutorialConfigSummary(),
        BaseConfigSummary(),
    ]

    private var totalGainedExperience: Int {
        return configs.map { $0.totalGainedExperience }.reduce(0, combine: +)
    }
    var spentExperience: Int {
        get { return Defaults["\(configKey)-spentExperience"].int ?? 0 }
        set { return Defaults["\(configKey)-spentExperience"] = newValue }
    }
    var availableExperience: Int {
        return totalGainedExperience - spentExperience
    }

    private var totalGainedResources: Int {
        return configs.map { $0.totalGainedResources }.reduce(0, combine: +)
    }
    var spentResources: Int {
        get { return Defaults["\(configKey)-spentResources"].int ?? 0 }
        set { return Defaults["\(configKey)-spentResources"] = newValue }
    }
    var availableResources: Int {
        return totalGainedResources - spentResources
    }

    func canAfford(amount: Currency) -> Bool {
        return availableExperience - amount.experience >= 0 && availableResources - amount.resources >= 0
    }

    func spent(amount: Currency) {
        if amount.experience > 0 {
            Defaults["\(configKey)-spentExperience"] = spentExperience + amount.experience
        }
        if amount.resources > 0 {
            Defaults["\(configKey)-spentResources"] = spentResources + amount.resources
        }
    }

}
