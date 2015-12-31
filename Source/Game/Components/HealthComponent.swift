//
//  HealthComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class HealthComponent: Component {
    typealias OnKilled = Block
    typealias OnHurt = (Float) -> Void
    private var _onKilled = [OnKilled]()
    func onKilled(handler: OnKilled) { _onKilled << handler }

    private var _onHurt = [OnHurt]()
    func onHurt(handler: OnHurt) { _onHurt << handler }

    private var startingHealth: Float
    var healthPercent: Float { return max(min(health / startingHealth, 1), 0) }
    var died = false
    private var health: Float

    override func reset() {
        super.reset()
        _onKilled = [OnKilled]()
    }

    init(health: Float) {
        startingHealth = health
        self.health = health
        super.init()
    }

    required override init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        startingHealth = coder.decodeFloat("startingHealth") ?? 0
        health = coder.decodeFloat("health") ?? 0
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(startingHealth, key: "startingHealth")
        encoder.encode(health, key: "health")
    }

    func inflict(damage: Float) {
        health -= damage
        if health <= 0 && !died {
            for handler in _onKilled {
                handler()
            }
            died = true
        }
    }

}
