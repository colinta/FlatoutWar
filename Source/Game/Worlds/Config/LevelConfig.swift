////
///  LevelConfig.swift
//

class LevelConfig: Config {
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
            let nodes: [Node]? = configs?.flatMap {
                return NodeStorage.fromDefaults($0)
            }
            return nodes ?? []
        }
        set {
            let storage: [NSDictionary] = newValue.map { NodeStorage.toDefaults($0) }.flatMap { $0 }
            Defaults["\(configKey)-storedPlayers"] = storage
        }
    }

    var storedPowerups: [(powerup: Powerup, order: Int?)] {
        get {
            let configs: [NSDictionary]? = Defaults["\(configKey)-storedPowerups"].array as? [NSDictionary]
            let powerups = configs?.flatMap {
                return PowerupStorage.fromDefaults($0)
            }.sort { a, b in
                if let orderA = a.order, orderB = a.order {
                    return orderA < orderB
                }
                else if a.order != nil {
                    return true
                }
                return false
            }
            return powerups ?? []
        }
        set {
            let storage: [NSDictionary] = newValue.map { entry in
                return PowerupStorage.toDefaults(entry.powerup, order: entry.order)
            }.flatMap { $0 }
            Defaults["\(configKey)-storedPowerups"] = storage
        }
    }

    var purchaseablePowerups: [Powerup] {
        return storedPowerups.filter { $0.order == nil }.map { $0.powerup }
    }

    var activatedPowerups: [Powerup] {
        return storedPowerups.flatMap { entry in
            if entry.order != nil {
                return entry.powerup
            }
            return nil
        }
    }
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
