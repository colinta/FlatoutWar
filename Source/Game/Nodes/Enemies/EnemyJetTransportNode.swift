//
//  EnemyJetTransportNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 15

class EnemyJetTransportNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 35
    var sprite = SKSpriteNode()
    var payload: [Node]?

    required init() {
        super.init()
        size = CGSize(40)

        sprite.zPosition = Z.Top.rawValue
        self << sprite

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { _ in
            self.updateTexture()
        }
        healthComponent.onKilled {
            self.generateKilledExplosion()
            self.removeFromParent()
        }
        addComponent(healthComponent)
        updateTexture()

        let enemyComponent = EnemyComponent()
        enemyComponent.intersectionNode = sprite
        enemyComponent.experience = 1
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.generateShrapnel(damage)
                self.healthComponent?.inflict(damage)
            }
        }
        addComponent(enemyComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func enemyType() -> ImageIdentifier.EnemyType {
        return .JetTransport
    }

    func updateTexture() {
        sprite.textureId(.Enemy(type: enemyType(), health: healthComponent?.healthInt ?? 100))
    }

    func transportPayload(payload: [Node]) {
        if let prevPayload = self.payload {
            for node in prevPayload {
                node.removeFromParent()
            }
        }

        guard let first = payload.first else { return }

        for node in payload {
            node.frozen = true
            self << node
        }
        self.payload = payload

        if payload.count == 1 {
            first.position = .zero
        }
        else {
            let numRows = Int(ceil(Float(payload.count) / 2))
            let dx = 2 * first.radius + 3
            var x = dx / 2 * CGFloat(numRows - 1)
            let y = dx / 2
            var even = true
            for node in payload {
                if payload.count % 2 == 1 && node == payload.last {
                    node.position = CGPoint(x, 0)
                }
                else if even {
                    node.position = CGPoint(x, y)
                }
                else {
                    node.position = CGPoint(x, -y)
                    x -= dx
                }
                even = !even
            }
        }
    }

    func generateKilledExplosion() {
        if let world = self.world {
            let explosion = EnemyExplosionNode(at: self.position)
            world << explosion
            self.generateBigShrapnel(dist: 10, angle: 0, spread: TAU)
        }
    }

    func generateBigShrapnel(dist dist: CGFloat, angle: CGFloat, spread: CGFloat) {
        if let world = self.world {
            let node = EnemyShrapnelNode(type: enemyType(), size: .Actual)
            node.setupAround(self, at: self.position,
                rotateSpeed: rand(min: 5, max: 8),
                distance: rand(10)
                )
            world << node
        }
    }

    func generateShrapnel(damage: Float) {
        if let world = self.world {
            Int(damage * 10).times {
                let node = EnemyShrapnelNode(type: enemyType(), size: .Small)
                node.setupAround(self)
                world << node
            }
        }
    }

}
