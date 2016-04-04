//
//  EnemyJetTransportNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 20

class EnemyJetTransportNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 35
    var sprite = SKSpriteNode()

    required init() {
        super.init()

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
        size = sprite.size

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

extension EnemyJetTransportNode {

    func runAway() {
        self.followComponent?.removeFromNode()
        let angle: CGFloat = zRotation + TAU_2 ± rand(TAU_4)
        let dist: CGFloat = rand(min: 15, max: 30)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func dodge() {
        self.followComponent?.removeFromNode()
        let angle: CGFloat = zRotation ± (TAU_4 - 10.degrees)
        let dist: CGFloat = rand(min: 20, max: 40)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func follow(leader: Node, scatter: Scatter = .RunAway, component: FollowComponent? = nil) {
        let followComponent = component ?? self.followComponent ?? FollowNodeComponent()

        playerTargetingComponent?.targetingEnabled = false
        rammingComponent?.currentTarget = nil

        followComponent.follow = leader

        switch scatter {
        case .RunAway:
            leader.healthComponent?.onKilled(self.runAway)
        case .Dodge:
            leader.healthComponent?.onKilled(self.dodge)
        case let .Custom(handler):
            leader.healthComponent?.onKilled {
                handler(self)
            }
        case .None: break
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
