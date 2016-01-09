//
//  NodeStorage.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NodeStorage {
    enum Type: Int {
        case Drone
    }

    static func fromDefaults(defaults: NSDictionary) -> Node? {
        guard let typeint = defaults["type"] as? Int else { return nil }
        guard let type: Type = Type(rawValue: typeint) else { return nil }

        let node: Node
        switch type {
        case .Drone: node = DroneNode()
        }

        if let x = defaults["position.x"] as? Float,
            y = defaults["position.y"] as? Float {
            node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }

        return node
    }

    static func toDefaults(node: Node) -> NSDictionary? {
        var type: Type?
        if node is DroneNode {
            type = .Drone
        }
        else {
            type = nil
        }

        if let type = type {
            let defaults = NSMutableDictionary()
            defaults["type"] = type.rawValue
            defaults["position.x"] = Float(node.position.x)
            defaults["position.y"] = Float(node.position.y)
            return defaults
        }
        return nil
    }

}
