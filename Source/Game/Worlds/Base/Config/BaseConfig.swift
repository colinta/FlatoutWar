//
//  BaseConfig.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfig {
    var key: String { return "\(self.dynamicType)" }

    var hasTutorial: Bool { return false }
    var canUpgrade: Bool { return false }
    var possibleExperience: Int { return 0 }

    var gainedExperience: Int {
        get { return Defaults["Config-\(key)-gainedExperience"].int ?? 0 }
    }
    var percentGainedExperience: CGFloat {
        return min(CGFloat(gainedExperience) / CGFloat(possibleExperience), 1)
    }
    var seenTutorial: Bool {
        get { return Defaults["Config-\(key)-seenTutorial"].bool ?? false }
        set { Defaults["Config-\(key)-seenTutorial"] = newValue }
    }
    var levelCompleted: Bool {
        return Defaults.hasKey("Config-\(key)-gainedExperience")
    }

    var storedPlayers: [Node] {
        get {
            let configs: [NSDictionary]? = Defaults["Config-\(key)-storedPlayers"].array as? [NSDictionary]
            let nodes: [Node?]? = configs?.map {
                return NodeStorage.fromDefaults($0)
            }
            let flattened: [Node]? = nodes?.flatMap { $0 }
            return flattened ?? []
        }
        set {
            let storage: [NSDictionary] = newValue.map { NodeStorage.toDefaults($0) }.flatMap { $0 }
            Defaults["Config-\(key)-storedPlayers"] = storage
        }
    }

    func updateMaxGainedExperience(exp: Int) {
        Defaults["Config-\(key)-gainedExperience"] = min(max(exp, gainedExperience), possibleExperience)
    }

}
