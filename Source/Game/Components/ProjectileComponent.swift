//
//  ProjectileComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class ProjectileComponent: Component {
    var damage = Float(0)
    typealias OnCollision = (projectile: Node, enemy: Node, location: CGPoint) -> Void
    var _onCollision = [OnCollision]()
    func onCollision(handler: OnCollision) { _onCollision << handler }

    override func reset() {
        super.reset()
        _onCollision = [OnCollision]()
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        let projectile = node
        guard let world = projectile.world else {
            return
        }

        for enemy in world.enemies {
            if let died = enemy.healthComponent?.died where died { continue }

            if let location = projectile.touchingLocation(enemy) {
                for handler in _onCollision {
                    handler(projectile: projectile, enemy: enemy, location: location)
                }

                if let enemyComponent = enemy.enemyComponent {
                    for handler in enemyComponent._onAttacked {
                        handler(projectile: projectile)
                    }
                }

                break
            }
        }
    }

}
