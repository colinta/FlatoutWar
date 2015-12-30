//
//  HealthComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class HealthComponent: Component {
    var health: Float

    init(health: Float) {
        self.health = health
        super.init()
    }

    required init?(coder: NSCoder) {
        health = coder.decodeFloat("health") ?? 0
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(health, key: "health")
    }

}
