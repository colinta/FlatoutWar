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
    var sprite = SKSpriteNode()

    required init() {
        super.init()
        size = CGSize(10)

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

        let targetingComponent = PlayerTargetingComponent()
        targetingComponent.onTargetAcquired { target in
            if let target = target {
                self.rotateTowards(target)
            }
        }
        addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.maxSpeed = EnemySoldierNode.DefaultSoldierSpeed
        rammingComponent.onRammed {
            self.generateRammingExplosion()
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
        sprite.textureId(.Enemy(type: enemyType(), health: healthComponent?.healthInt ?? 100))
    }

    func generateRammingExplosion() {
        if let world = self.world {
            let explosion = EnemyAttackExplosionNode(at: self.position)
            explosion.zRotation = self.zRotation
            world << explosion
            generateBigShrapnel(dist: 60, angle: zRotation + TAU_2, spread: TAU_16)
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
            let locations = [
                world.convertPoint(CGPoint(x: radius / 2, y: radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x: radius / 2, y:-radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x:-radius / 2, y: radius / 2), fromNode: self),
                world.convertPoint(CGPoint(x:-radius / 2, y:-radius / 2), fromNode: self),
            ]
            4.times { (i: Int) in
                let node = EnemyShrapnelNode(type: enemyType(), size: .Big)
                node.setupAround(self, at: locations[i])
                let dest = CGPoint(r: rand(min: dist, max: dist * 1.5), a: angle ± rand(spread))
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
        self.followComponent?.removeFromNode()
        let angle: CGFloat = zRotation + TAU_2 ± rand(TAU_4)
        let dist: CGFloat = rand(min: 15, max: 30)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func follow(leader: Node, scatter: Bool = true, component: FollowComponent? = nil) {
        let followComponent = component ?? self.followComponent ?? FollowNodeComponent()

        playerTargetingComponent?.targetingEnabled = false
        rammingComponent?.currentTarget = nil

        followComponent.follow = leader

        if scatter {
            leader.healthComponent?.onKilled(self.scatter)
        }
        leader.onDeath { [weak self] in
            if let wSelf = self {
                wSelf.rammingComponent?.currentSpeed = leader.rammingComponent?.currentSpeed ?? 0
                wSelf.rammingComponent?.currentTarget = leader.rammingComponent?.currentTarget
                wSelf.playerTargetingComponent?.currentTarget = leader.playerTargetingComponent?.currentTarget
                wSelf.playerTargetingComponent?.targetingEnabled = true
                wSelf.followComponent?.removeFromNode()
            }
        }
        addComponent(followComponent)
    }

}
