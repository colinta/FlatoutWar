////
///  NodeStorage.swift
//

class NodeStorage {
    enum NodeType: Int {
        case drone
        case basePlayer
    }

    static func fromDefaults(_ defaults: NSDictionary) -> Node? {
        guard let typeint = defaults["type"] as? Int else { return nil }
        guard let type: NodeType = NodeType(rawValue: typeint) else { return nil }

        let node: Node
        switch type {
        case .basePlayer:
            let player = BasePlayerNode()
            player.movementUpgrade = HasUpgrade(safe: defaults["movementUpgrade"] as? Bool)
            player.bulletUpgrade = HasUpgrade(safe: defaults["bulletUpgrade"] as? Bool)
            player.radarUpgrade = HasUpgrade(safe: defaults["radarUpgrade"] as? Bool)
            node = player
        case .drone:
            let drone = DroneNode()
            drone.movementUpgrade = HasUpgrade(safe: defaults["movementUpgrade"] as? Bool)
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
        let type: NodeType?
        if let node = node as? BasePlayerNode {
            type = .basePlayer
            defaults["movementUpgrade"] = node.movementUpgrade.boolValue
            defaults["bulletUpgrade"] = node.bulletUpgrade.boolValue
            defaults["radarUpgrade"] = node.radarUpgrade.boolValue
        }
        else if let node = node as? DroneNode {
            type = .drone
            defaults["movementUpgrade"] = node.movementUpgrade.boolValue
            defaults["bulletUpgrade"] = node.bulletUpgrade.boolValue
            defaults["radarUpgrade"] = node.radarUpgrade.boolValue
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
