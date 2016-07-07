//
//  BombNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/10/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BombNode: Node {
    let sprite = SKSpriteNode()
    let rate: CGFloat = 1
    let maxRadius: Int
    var attack: Block!
    var time: CGFloat = 0
    var damage: CGFloat = 5

    required convenience init() {
        self.init(maxRadius: 40)
    }

    required init(maxRadius: Int) {
        self.maxRadius = maxRadius
        super.init()
        attack = once(damageTargets)
        sprite.textureId(.Bomb(radius: maxRadius, time: 0))
        self << sprite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        attack()

        time += dt * rate
        guard time < 1 else {
            sprite.textureId(.None)
            removeFromParent()
            return
        }

        sprite.textureId(.Bomb(radius: maxRadius, time: Int(time * 250)))
    }

    private func damageTargets() {
        guard let world = world else { return }
        let maxRadius = CGFloat(self.maxRadius)

        for enemy in world.enemies where enemy.enemyComponent!.targetable {
            let enemyPosition = convertPosition(enemy)
            let distance: CGFloat = abs(enemyPosition.length - enemy.radius)
            if distance <= maxRadius {
                let enemyDamage = Float(interpolate(distance / maxRadius, from: (0, 1), to: (damage, damage / 2)))
                enemy.healthComponent?.inflict(enemyDamage)
            }
        }
    }
}
