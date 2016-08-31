////
///  PowerupStorage.swift
//

class PowerupStorage {
    enum Type: Int {
        case Bomber
        case Coffee
        case Decoy
        case Grenade
        case Hourglass
        case Laser
        case Mines
        case Net
        case Pulse
        case Shield
        case Soldiers
    }

    static func fromDefaults(defaults: NSDictionary) -> (powerup: Powerup, order: Int?)? {
        guard let typeint = defaults["type"] as? Int,
            type: Type = Type(rawValue: typeint),
            count: Int = defaults["count"] as? Int else
        {
            return nil
        }

        let powerup: Powerup
        switch type {
        case .Bomber:
            powerup = BomberPowerup(count: count)
        case .Coffee:
            powerup = CoffeePowerup(count: count)
        case .Decoy:
            powerup = DecoyPowerup(count: count)
        case .Grenade:
            powerup = GrenadePowerup(count: count)
        case .Hourglass:
            powerup = HourglassPowerup(count: count)
        case .Laser:
            powerup = LaserPowerup(count: count)
        case .Mines:
            powerup = MinesPowerup(count: count)
        case .Net:
            powerup = NetPowerup(count: count)
        case .Pulse:
            powerup = PulsePowerup(count: count)
        case .Shield:
            powerup = ShieldPowerup(count: count)
        case .Soldiers:
            powerup = SoldiersPowerup(count: count)
        }

        let order = defaults["order"] as? Int
        return (powerup: powerup, order: order)
    }

    static func toDefaults(powerup: Powerup, order: Int?) -> NSDictionary? {
        let type: Type?
        if powerup is BomberPowerup {
            type = .Bomber
        }
        else if powerup is CoffeePowerup {
            type = .Coffee
        }
        else if powerup is DecoyPowerup {
            type = .Decoy
        }
        else if powerup is GrenadePowerup {
            type = .Grenade
        }
        else if powerup is HourglassPowerup {
            type = .Hourglass
        }
        else if powerup is LaserPowerup {
            type = .Laser
        }
        else if powerup is MinesPowerup {
            type = .Mines
        }
        else if powerup is NetPowerup {
            type = .Net
        }
        else if powerup is PulsePowerup {
            type = .Pulse
        }
        else if powerup is ShieldPowerup {
            type = .Shield
        }
        else if powerup is SoldiersPowerup {
            type = .Soldiers
        }
        else {
            type = nil
        }

        if let type = type {
            let defaults = NSMutableDictionary()
            defaults["type"] = type.rawValue
            defaults["count"] = powerup.count
            defaults["order"] = order
            return defaults
        }
        return nil
    }

}
