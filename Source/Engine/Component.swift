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

    func update(dt: CGFloat, node: Node) {
    }

    func reset() {
    }

    override init() {
    }

    required init?(coder: NSCoder) {
        super.init()
        enabled = coder.decodeBool("enabled") ?? true
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encode(enabled, key: "enabled")
    }

}

class FiringComponent: Component {}
class FollowNodeComponent: Component {}
class GrowToComponent: Component {}
class MoveableComponent: Component {}
class PhaseComponent: Component {}
class RammableComponent: Component {}
class RammingComponent: Component {}
class TraversingComponent: Component {}
class WanderingComponent: Component {}
