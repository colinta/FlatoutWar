//
//  UpgradeConfigSummary.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
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

    func canAfford(experience: Int) -> Bool {
        return availableExperience - experience >= 0
    }

    func spent(experience: Int) {
        Defaults["\(configKey)-spentExperience"] = spentExperience + experience
    }

}
