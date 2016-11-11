////
///  NodeStorage.swift
//

class NodeStorage {
    enum PowerupType: Int {
        case Drone
        case BasePlayer
    }

    static func fromDefaults(_ defaults: NSDictionary) -> Node? {
        guard let typeint = defaults["type"] as? Int else { return nil }
        guard let type: PowerupType = PowerupType(rawValue: typeint) else { return nil }

        let node: Node
        switch type {
        case .BasePlayer:
            let player = BasePlayerNode()
            player.rotateUpgrade = HasUpgrade(safe: defaults["rotateUpgrade"] as? Bool)
            player.bulletUpgrade = HasUpgrade(safe: defaults["bulletUpgrade"] as? Bool)
            player.radarUpgrade = HasUpgrade(safe: defaults["radarUpgrade"] as? Bool)
            player.turretUpgrade = HasUpgrade(safe: defaults["turretUpgrade"] as? Bool)
            node = player
        case .Drone:
            let drone = DroneNode()
            drone.speedUpgrade = HasUpgrade(safe: defaults["speedUpgrade"] as? Bool)
            drone.bulletUpgrade = HasUpgrade(safe: defaults["bulletUpgrade"] as? Bool)
            drone.radarUpgrade = HasUpgrade(safe: defaults["radarUpgrade"] as? Bool)
            node = drone
        }

        if let x = defaults["position.x"] as? Float,
            let y = defaults["position.y"] as? Float {
            node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }

        return node
    }

    static func toDefaults(node: Node) -> NSDictionary? {
        let defaults = NSMutableDictionary()
        let type: PowerupType?
        if let node = node as? BasePlayerNode {
            type = .BasePlayer
            defaults["radarUpgrade"] = node.radarUpgrade.boolValue
            defaults["turretUpgrade"] = node.turretUpgrade.boolValue
        }
        else if let node = node as? DroneNode {
            type = .Drone
            defaults["speedUpgrade"] = node.speedUpgrade.boolValue
            defaults["radarUpgrade"] = node.radarUpgrade.boolValue
            defaults["bulletUpgrade"] = node.bulletUpgrade.boolValue
        }
        else {
            type = nil
        }

        if let type = type {
            defaults["type"] = type.rawValue
            defaults["position.x"] = Float(node.position.x)
            defaults["position.y"] = Float(node.position.y)
            return defaults
        }
        return nil
    }

}
