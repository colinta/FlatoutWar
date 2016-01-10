//
//  EnemySoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 2

class EnemySoldierNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 25
    var sprite: SKSpriteNode!

    required init() {
        super.init()
        size = CGSize(10)

        sprite = SKSpriteNode(id: .None)
        updateTexture()
        self << sprite

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
        enemyComponent.intersectionNode = sprite
        enemyComponent.experience = 1
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.generateShrapnel(damage)
                self.healthComponent?.inflict(damage)
            }
        }
        enemyComponent.onTargetAcquired { target in
            if let target = target {
                self.rotateTowards(target)
            }
        }
        addComponent(enemyComponent)

        let rammingComponent = RammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.bindTo(enemyComponent: enemyComponent)
        rammingComponent.maxSpeed = EnemySoldierNode.DefaultSoldierSpeed
        rammingComponent.onRammed {
            self.generateExplosion()
            self.removeFromParent()
        }
        rammingComponent.damage = startingHealth * 2
        addComponent(rammingComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func enemyType() -> ImageIdentifier.EnemyType {
        return .Soldier
    }

    func updateTexture() {
        let texture = SKTexture.id(.Enemy(type: enemyType(), health: healthComponent?.healthInt ?? 100))
        sprite.texture = texture
        sprite.size = texture.size() * sprite.xScale
    }

    func generateExplosion() {
        if let world = self.world {
            let node = EnemyAttackExplosionNode(at: self.position)
            node.zRotation = self.zRotation
            world << node

            let locations = [
                world.convertPoint(CGPoint(x: radius / 2, y: radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x: radius / 2, y:-radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x:-radius / 2, y: radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x:-radius / 2, y:-radius / 2), fromNode: self),
            ]
            4.times { (i: Int) in
                let node = EnemyShrapnelNode(type: enemyType(), size: .Big)
                node.setupAround(self, at: locations[i])
                let dest = CGPoint(r: rand(min: 60, max: 90), a: zRotation + TAU_2)
                node.moveToComponent?.target = node.position + dest
                world << node
            }
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

extension EnemySoldierNode {

    func scatter() {
        let angle: CGFloat = zRotation + TAU_2 ± rand(TAU_4)
        let dist: CGFloat = rand(min: 15, max: 30)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func follow(leader: Node, scatter: Bool = true) {
        let followNodeComponent = self.followNodeComponent ?? FollowNodeComponent()

        enemyComponent?.targetingEnabled = false
        rammingComponent?.currentTarget = nil
        followNodeComponent.follow = leader
        if scatter {
            leader.healthComponent?.onKilled(self.scatter)
        }
        leader.onDeath { [weak self] in
            if let wSelf = self {
                wSelf.rammingComponent?.currentSpeed = leader.rammingComponent?.currentSpeed ?? 0
                wSelf.rammingComponent?.currentTarget = leader.rammingComponent?.currentTarget
                wSelf.enemyComponent?.currentTarget = leader.enemyComponent?.currentTarget
                wSelf.enemyComponent?.targetingEnabled = true
                wSelf.followNodeComponent?.removeFromNode()
            }
        }
        addComponent(followNodeComponent)
    }

}
