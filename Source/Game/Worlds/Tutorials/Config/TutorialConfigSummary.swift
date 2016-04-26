//
//  TutorialConfigSummary
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialConfigSummary {
    let configs: [BaseConfig] = [
        TutorialLevel1Config(),
        TutorialLevel2Config(),
        TutorialLevel3Config(),
        TutorialLevel4Config(),
        TutorialLevel5Config(),
    ]

    var totalGainedExperience: Int {
        return configs.map { $0.gainedExperience }.reduce(0, combine: +)
    }
    var availableExperience: Int {
        return totalGainedExperience - spentExperience
    }
    var spentExperience: Int {
        get { return Defaults["Config-TutorialConfigSummary-spentExperience"].int ?? 0 }
    }
    var worldCompleted: Bool {
        return configs.all { $0.levelCompleted }
    }

    func completeAll() {
        for c in configs {
            c.updateMaxGainedExperience(c.possibleExperience)
        }
    }

    func resetAll() {
        for c in configs {
            c.levelCompleted = false
        }
    }

    func canAfford(experience: Int) -> Bool {
        return availableExperience - experience >= 0
    }

    func spent(experience: Int) {
        Defaults["Config-BaseConfigSummary-spentExperience"] = spentExperience + experience
    }

}
