//
//  Component.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

@objc
class Component: NSObject, NSCoding {
    var enabled = true
    weak var node: Node!

    func update(dt: CGFloat) {
    }

    func reset() {
    }

    override init() {
    }

    func removeFromNode() {
        if let node = node {
            node.removeComponent(self)
        }
        node = nil
    }

    required init?(coder: NSCoder) {
        super.init()
        enabled = coder.decodeBool("enabled") ?? true
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encode(enabled, key: "enabled")
    }

}

class FollowNodeComponent: Component {}
class GrowToComponent: Component {}
