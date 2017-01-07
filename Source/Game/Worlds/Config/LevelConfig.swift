////
///  LevelConfig.swift
//

class LevelConfig: Config {
    var didUpgrade: Bool {
        get { return Defaults["\(configKey)-didUpgrade"].bool ?? false }
        set { Defaults["\(configKey)-didUpgrade"] = newValue }
    }
    var canPowerup: Bool { return true }
    var trackExperience: Bool { return true }

    var possibleExperience: Int { return 0 }
    var gainedExperience: Int {
        get { return Defaults["\(configKey)-gainedExperience"].int ?? 0 }
    }
    var percentCompleted: CGFloat {
        return min(CGFloat(gainedExperience) / CGFloat(possibleExperience), 1)
    }
    var levelCompleted: Bool {
        get { return Defaults.hasKey("\(configKey)-gainedExperience") }
        set {
            if !newValue {
                Defaults.remove("\(configKey)-gainedExperience")
            }
        }
    }

    var storedPowerups: [(powerup: Powerup, order: Int?)] {
        get {
            if let configs: [NSDictionary] = Defaults["\(configKey)-storedPowerups"].array as? [NSDictionary] {
                let powerups = configs.flatMap {
                    return PowerupStorage.fromDefaults(defaults: $0)
                }.sorted { a, b in
                    if let orderA = a.order, let orderB = a.order {
                        return orderA < orderB
                    }
                    else if a.order != nil {
                        return true
                    }
                    return false
                }
                return powerups
            }
            else {
                return []
            }
        }
        set {
            let storage: [NSDictionary] = newValue.map { entry in
                return PowerupStorage.toDefaults(powerup: entry.powerup, order: entry.order)
            }.flatMap { $0 }
            Defaults["\(configKey)-storedPowerups"] = storage
        }
    }

    var purchaseablePowerups: [Powerup] {
        return storedPowerups.filter { $0.order == nil }.map { $0.powerup }
    }

    func appendPowerup(_ powerup: Powerup) {
        guard !storedPowerups.any({ $0.powerup == powerup }) else { return }

        storedPowerups = storedPowerups + [(powerup: powerup, order: nil)]
    }

    func updatePowerup(_ powerup: Powerup) {
        let storage: [NSDictionary] = storedPowerups.map { entry in
            let entryPowerup: Powerup
            if entry.powerup == powerup {
                entryPowerup = powerup
            }
            else {
                entryPowerup = entry.powerup
            }
            return PowerupStorage.toDefaults(powerup: entryPowerup, order: entry.order)
        }.flatMap { $0 }
        Defaults["\(configKey)-storedPowerups"] = storage
    }

    func replacePowerup(_ prevPowerup: Powerup, with newPowerup: Powerup) {
        let storage: [NSDictionary] = storedPowerups.map { entry in
            let entryPowerup: Powerup
            if entry.powerup == prevPowerup {
                entryPowerup = newPowerup
            }
            else if entry.powerup == newPowerup {
                entryPowerup = prevPowerup
            }
            else {
                entryPowerup = entry.powerup
            }
            return PowerupStorage.toDefaults(powerup: entryPowerup, order: entry.order)
        }.flatMap { $0 }
        Defaults["\(configKey)-storedPowerups"] = storage
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

    func updateMaxGainedExperience(_ exp: Int) {
        Defaults["\(configKey)-gainedExperience"] = min(max(exp, gainedExperience), possibleExperience)
    }

    func nextLevel() -> Level {
        fatalError("nextLevel() has not been implemented by \(type(of: self))")
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
