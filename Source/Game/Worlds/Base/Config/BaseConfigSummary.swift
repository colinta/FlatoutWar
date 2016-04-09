//
//  BaseConfigSummary.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfigSummary {
    let configs: [BaseConfig] = [
        BaseLevel1Config(),
        BaseLevel2Config(),
        BaseLevel3Config(),
        BaseLevel4Config(),
        BaseLevel5Config(),
        BaseLevel6Config(),
        BaseLevel7Config(),
        BaseLevel8Config(),
        BaseLevel9Config(),
    ]

    var totalGainedExperience: Int {
        return configs.map { $0.gainedExperience }.reduce(0, combine: +)
    }
    var availableExperience: Int {
        return totalGainedExperience - spentExperience
    }
    var spentExperience: Int {
        get { return Defaults["Config-BaseConfigSummary-spentExperience"].int ?? 0 }
    }

    func canAfford(experience: Int) -> Bool {
        return availableExperience - experience >= 0
    }

    func spent(experience: Int) {
        Defaults["Config-BaseConfigSummary-spentExperience"] = spentExperience + experience
    }

}
