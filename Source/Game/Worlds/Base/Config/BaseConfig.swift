//
//  BaseConfig.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfig {
    var key: String { return "\(self.dynamicType)" }
    var sharedKey: String { return "BaseConfig" }
    var possibleExperience: Int { return 0 }
    var gainedExperience: Int {
        get { return Defaults["Config-\(key)-gainedExperience"].int ?? 0 }
        set {
            Defaults["Config-\(key)-gainedExperience"] = max(newValue, gainedExperience)
        }
    }
    var hasTutorial: Bool { return false }
    var canUpgrade: Bool { return false }
    var seenTutorial: Bool {
        get { return Defaults["Config-\(key)-seenTutorial"].bool ?? false }
        set { Defaults["Config-\(key)-seenTutorial"] = newValue }
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

}
