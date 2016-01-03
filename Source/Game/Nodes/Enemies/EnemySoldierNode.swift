//
//  EnemySoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 2

class EnemySoldierNode: Node {
    static let DefaultSpeed: CGFloat = 25
    var sprite: SKSpriteNode!

    required init() {
        super.init()
        size = CGSize(10)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { _ in
            self.updateTexture()
        }
        healthComponent.onKilled {
            if let world = self.world {
                let explosion = EnemyExplosionNode(at: self.position)
                world << explosion
            }
            self.removeFromParent()
        }
        addComponent(healthComponent)

        let enemyComponent = EnemyComponent()
        enemyComponent.experience = 1
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.generateShrapnel(damage)
                self.healthComponent?.inflict(damage)
            }
        }
        addComponent(enemyComponent)

        let rammingComponent = RammingComponent()
        rammingComponent.maxSpeed = EnemySoldierNode.DefaultSpeed
        rammingComponent.onRammed {
            if let world = self.world {
                let node = EnemyAttackExplosionNode(at: self.position)
                node.zRotation = self.zRotation
                world << node
            }
            self.removeFromParent()
        }
        rammingComponent.damage = 4
        addComponent(rammingComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func populate() {
        sprite = SKSpriteNode(id: .None)
        updateTexture()
        self << sprite
    }

    func enemyType() -> ImageIdentifier.EnemyType {
        return .Soldier
    }

    func updateTexture() {
        let texture = SKTexture.id(.Enemy(type: enemyType(), health: healthComponent?.healthInt ?? 100))
        sprite.texture = texture
        sprite.size = texture.size() * sprite.xScale
    }

    func generateShrapnel(damage: Float) {
        if let world = self.world {
            Int(damage * 10).times {
                let node = EnemyShrapnelNode(type: .Soldier)
                node.position = self.position
                let rotate = KeepRotatingComponent()
                rotate.rate = rand(min: 1, max: 2)
                node.addComponent(rotate)

                let duration: CGFloat = 0.5

                let move = MoveToComponent()
                let dest = CGPoint(r: rand(min: 15, max: 30), a: rand(TAU))
                move.target = self.position + dest
                move.duration = duration
                node.addComponent(move)

                let fade = FadeToComponent()
                fade.target = 0
                fade.duration = duration
                fade.removeNodeOnFade()
                node.addComponent(fade)

                world << node
            }
        }
    }

}

extension EnemySoldierNode {

    func scatter() {
        let angle: CGFloat = zRotation + TAU_2 ± rand(TAU_4)
        let dist: CGFloat = rand(min: 15, max: 30)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func follow(node: Node, scatter: Bool = true) {
        if let followNodeComponent = self.followNodeComponent {
            followNodeComponent.removeFromNode()
        }

        rammingComponent?.enabled = false
        let followNodeComponent = FollowNodeComponent()
        followNodeComponent.node = self
        followNodeComponent.follow = node
        if scatter {
            node.healthComponent?.onKilled {
                self.scatter()
            }
        }
        node.onDeath { [weak self] in
            if let wSelf = self {
                wSelf.rammingComponent?.currentSpeed = node.rammingComponent?.currentSpeed ?? 0
                wSelf.rammingComponent?.enabled = true
                if let followNodeComponent = wSelf.followNodeComponent
                    where followNodeComponent.follow == node
                {
                    followNodeComponent.removeFromNode()
                }
            }
        }
        addComponent(followNodeComponent)
    }

}
