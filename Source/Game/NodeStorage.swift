////
///  NodeStorage.swift
//

class NodeStorage {
    enum Type: Int {
        case Drone
        case BasePlayer
    }

    static func fromDefaults(defaults: NSDictionary) -> Node? {
        guard let typeint = defaults["type"] as? Int else { return nil }
        guard let type: Type = Type(rawValue: typeint) else { return nil }

        let node: Node
        switch type {
        case .BasePlayer:
            let player = BasePlayerNode()
            player.radarUpgrade = FiveUpgrades(safe: defaults["radarUpgrade"] as? Int)
            player.turretUpgrade = FiveUpgrades(safe: defaults["turretUpgrade"] as? Int)
            node = player
        case .Drone:
            let drone = DroneNode()
            drone.upgrade = FiveUpgrades(safe: defaults["upgrade"] as? Int)
            node = drone
        }

        if let x = defaults["position.x"] as? Float,
            y = defaults["position.y"] as? Float {
            node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }

        return node
    }

    static func toDefaults(node: Node) -> NSDictionary? {
        let defaults = NSMutableDictionary()
        let type: Type?
        if let node = node as? BasePlayerNode {
            type = .BasePlayer
            defaults["radarUpgrade"] = node.radarUpgrade.int
            defaults["turretUpgrade"] = node.turretUpgrade.int
        }
        else if let node = node as? DroneNode {
            type = .Drone
            defaults["upgrade"] = node.upgrade.int
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
