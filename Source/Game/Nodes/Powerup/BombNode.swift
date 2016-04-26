//
//  BombNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/10/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BombNode: Node {
    let sprite = SKSpriteNode()
    let rate: CGFloat = 0.5
    let maxRadius: Int
    var time: CGFloat = 0
    var damage: Float = 5

    required convenience init() {
        self.init(maxRadius: 40)
    }

    required init(maxRadius: Int) {
        self.maxRadius = maxRadius
        super.init()
        sprite.textureId(.Bomb(radius: maxRadius, time: 0))
        self << sprite
    }

    required init?(coder: NSCoder) {
        self.maxRadius = 0
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        time += dt * rate
        guard time < 1 else {
            sprite.textureId(.None)
            self.removeFromParent()
            return
        }

        sprite.textureId(.Bomb(radius: maxRadius, time: Int(time * 250)))
        damageTargets(dt)
    }

    func damageToTarget(enemy: Node) -> Float? {
        guard let world = world
            where world.enemies.contains(enemy) && enemy.enemyComponent!.targetable else
        {
            return nil
        }

        let radius = sprite.size.width / 2
        let enemyPosition = convertPosition(enemy)
        let distance: CGFloat = abs(enemyPosition.length - enemy.radius)
        if distance <= radius {
            return damage * Float(1 - distance / radius)
        }
        return nil
    }

    private func damageTargets(dt: CGFloat) {
        guard let world = world else { return }

        for enemy in world.enemies where enemy.enemyComponent!.targetable {
            if let damage = damageToTarget(enemy) {
                enemy.healthComponent?.inflict(damage * Float(dt))
            }
        }
    }
}
