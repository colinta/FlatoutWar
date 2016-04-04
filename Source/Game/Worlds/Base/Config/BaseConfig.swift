//
//  BaseConfig.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfig {
    var configKey: String { return "\(self.dynamicType)" }

    // display powerup at startup?
    var canPowerup: Bool { return true }
    // display upgrades at level end?
    var canUpgrade: Bool { return true }

    var possibleExperience: Int { return 0 }
    var gainedExperience: Int {
        get { return Defaults["Config-\(configKey)-gainedExperience"].int ?? 0 }
    }
    var percentGainedExperience: CGFloat {
        return min(CGFloat(gainedExperience) / CGFloat(possibleExperience), 1)
    }
    var levelCompleted: Bool {
        return Defaults.hasKey("Config-\(configKey)-gainedExperience")
    }

    var storedPlayers: [Node] {
        get {
            let configs: [NSDictionary]? = Defaults["Config-\(configKey)-storedPlayers"].array as? [NSDictionary]
            let nodes: [Node?]? = configs?.map {
                return NodeStorage.fromDefaults($0)
            }
            let flattened: [Node]? = nodes?.flatMap { $0 }
            return flattened ?? []
        }
        set {
            let storage: [NSDictionary] = newValue.map { NodeStorage.toDefaults($0) }.flatMap { $0 }
            Defaults["Config-\(configKey)-storedPlayers"] = storage
        }
    }

    var availablePowerups: [Powerup] { return [
        GrenadePowerup(),
        LaserPowerup(),
        MinesPowerup(),
    ] }
    var availableTurrets: [Turret] { return [
        SimpleTurret(),
        RapidTurret(),
    ] }

    func updateMaxGainedExperience(exp: Int) {
        Defaults["Config-\(configKey)-gainedExperience"] = min(max(exp, gainedExperience), possibleExperience)
    }

    func nextLevel() -> BaseLevel {
        fatalError("nextLevel() has not been implemented by \(self.dynamicType)")
    }

    func tutorial() -> Tutorial? {
        return nil
    }

}
