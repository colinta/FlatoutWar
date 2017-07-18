////
///  PowerupStorage.swift
//

class PowerupStorage {
    enum PowerupType: Int {
        case grenade
        case laser
        case mines
        case hourglass
        case soldiers
        case net
        case shield
        case coffee
        case pulse
        case bomber
    }

    static func fromDefaults(defaults: NSDictionary) -> (powerup: Powerup, order: Int?)? {
        guard let typeint = defaults["type"] as? Int,
            let type: PowerupType = PowerupType(rawValue: typeint),
            let count: Int = defaults["count"] as? Int else
        {
            return nil
        }

        let powerup: Powerup
        switch type {
        case .bomber:
            powerup = BomberPowerup(count: count)
        case .coffee:
            powerup = CoffeePowerup(count: count)
        case .grenade:
            powerup = GrenadePowerup(count: count)
        case .hourglass:
            powerup = HourglassPowerup(count: count)
        case .laser:
            powerup = LaserPowerup(count: count)
        case .mines:
            powerup = MinesPowerup(count: count)
        case .net:
            powerup = NetPowerup(count: count)
        case .pulse:
            powerup = PulsePowerup(count: count)
        case .shield:
            powerup = ShieldPowerup(count: count)
        case .soldiers:
            powerup = SoldiersPowerup(count: count)
        }

        let order = defaults["order"] as? Int
        return (powerup: powerup, order: order)
    }

    static func toDefaults(powerup: Powerup, order: Int?) -> NSDictionary? {
        let type: PowerupType?
        if powerup is BomberPowerup {
            type = .bomber
        }
        else if powerup is CoffeePowerup {
            type = .coffee
        }
        else if powerup is GrenadePowerup {
            type = .grenade
        }
        else if powerup is HourglassPowerup {
            type = .hourglass
        }
        else if powerup is LaserPowerup {
            type = .laser
        }
        else if powerup is MinesPowerup {
            type = .mines
        }
        else if powerup is NetPowerup {
            type = .net
        }
        else if powerup is PulsePowerup {
            type = .pulse
        }
        else if powerup is ShieldPowerup {
            type = .shield
        }
        else if powerup is SoldiersPowerup {
            type = .soldiers
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
