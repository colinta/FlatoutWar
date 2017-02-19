////
///  GameConfigSummary.swift
//

class GameConfigSummary: Config {
    var configs: [ConfigSummary] = [
        TutorialConfigSummary(),
        WoodsConfigSummary(),
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

    func canAfford(_ amount: Currency) -> Bool {
        return availableExperience - amount.experience >= 0
    }

    func spent(_ amount: Currency) {
        if amount.experience > 0 {
            spentExperience += amount.experience
        }
    }
}
