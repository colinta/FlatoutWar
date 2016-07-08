//
//  BaseConfig.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfig: Config {
    var canPowerup: Bool { return true }
    var canUpgrade: Bool { return true }
    var trackExperience: Bool { return true }
    var trackResources: Bool { return true }

    var possibleExperience: Int { return 0 }
    var expectedResources: Int { return 0 }
    var gainedExperience: Int {
        get { return Defaults["\(configKey)-gainedExperience"].int ?? 0 }
    }
    var gainedResources: Int {
        get { return Defaults["\(configKey)-gainedResources"].int ?? 0 }
    }
    var percentCompleted: CGFloat {
        return min(CGFloat(gainedExperience + min(gainedResources, expectedResources)) / CGFloat(possibleExperience + expectedResources), 1)
    }
    var levelCompleted: Bool {
        get { return Defaults.hasKey("\(configKey)-gainedExperience") }
        set {
            if !newValue {
                Defaults.remove("\(configKey)-gainedExperience")
            }
        }
    }

    var storedPlayers: [Node] {
        get {
            let configs: [NSDictionary]? = Defaults["\(configKey)-storedPlayers"].array as? [NSDictionary]
            let nodes: [Node?]? = configs?.map {
                return NodeStorage.fromDefaults($0)
            }
            let flattened: [Node]? = nodes?.flatMap { $0 }
            return flattened ?? []
        }
        set {
            let storage: [NSDictionary] = newValue.map { NodeStorage.toDefaults($0) }.flatMap { $0 }
            Defaults["\(configKey)-storedPlayers"] = storage
        }
    }

    var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }
    var availableTurrets: [Turret] { return [
        SimpleTurret(),
        RapidTurret(),
    ] }

    func updateMaxGainedExperience(exp: Int) {
        Defaults["\(configKey)-gainedExperience"] = min(max(exp, gainedExperience), possibleExperience)
    }

    func updateMaxGainedResources(exp: Int) {
        Defaults["\(configKey)-gainedResources"] = max(exp, gainedResources)
    }

    func nextLevel() -> Level {
        fatalError("nextLevel() has not been implemented by \(self.dynamicType)")
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
