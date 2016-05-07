//
//  ConfigSummary.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ConfigSummary: Config {
    var configs: [BaseConfig]

    override init() {
        configs = []
        super.init()
    }

    var totalGainedExperience: Int {
        return configs.map { $0.gainedExperience }.reduce(0, combine: +)
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
}
