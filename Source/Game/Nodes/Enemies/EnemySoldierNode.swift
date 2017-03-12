////
///  EnemySoldierNode.swift
//

private let StartingHealth: Float = 2
private let Damage: Float = 4
private let Experience = 1

class EnemySoldierNode: Node {
    static let DefaultSoldierSpeed: CGFloat = 25
    var sprite = SKSpriteNode()
    var rammingDamage: Float = Damage
    var initialAimTowardsTarget = true

    enum Scatter {
        case RunAway
        case Dodge
        case Custom((Node) -> Void)
        case None
    }

    required init() {
        super.init()

        name = "soldier"
        size = CGSize(10)

        self << sprite
        sprite.lightingBitMask   = 0xFFFFFFFF
        sprite.shadowCastBitMask = 0xFFFFFFFF

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { _ in
            self.onHurt()
        }
        healthComponent.onKilled(self.onKilled)
        addComponent(healthComponent)
        updateTexture()

        let enemyComponent = EnemyComponent()
        enemyComponent.intersectionNode = sprite
        enemyComponent.experience = Experience
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.generateBulletShrapnel(damage: damage)
                self.healthComponent?.inflict(damage: damage)
            }
        }
        addComponent(enemyComponent)

        let targetingComponent = PlayerTargetingComponent()
        targetingComponent.onTargetAcquired { target in
            if let target = target, self.initialAimTowardsTarget {
                self.initialAimTowardsTarget = false
                self.rotateTowards(target)
            }
        }
        addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.maxSpeed = EnemySoldierNode.DefaultSoldierSpeed
        rammingComponent.onRammed(self.onRammed)
        addComponent(rammingComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func onRammed(player: Node) {
        player.healthComponent?.inflict(damage: rammingDamage)
        rammingDamage = 0
        rammingComponent?.enabled = false
        generateRammingExplosion()
        scaleTo(0, duration: 0.1, removeNode: true)
    }

    func enemyType() -> ImageIdentifier.EnemyType {
        return .Soldier
    }

    func updateTexture() {
        sprite.textureId(.Enemy(enemyType(), health: healthComponent?.healthInt ?? 100))
    }

    func onHurt() {
        _ = world?.channel?.play(Sound.EnemyHurt)
        updateTexture()
    }

    func generateRammingExplosion() {
        guard let parent = parent else { return }

        let explosion = EnemyAttackExplosionNode(at: self.position)
        explosion.zRotation = self.zRotation
        parent << explosion
        generateBigShrapnel(distance: 60, angle: zRotation + TAU_2, spread: TAU_16)
    }

    func onKilled() {
        if let parent = parent {
            let explosion = EnemyExplosionNode(at: self.position)
            parent << explosion
            self.generateBigShrapnel(distance: 10, angle: 0, spread: TAU)
        }

        self.scaleTo(0, duration: 0.1, removeNode: true)
    }

    func generateBigShrapnel(distance dist: CGFloat, angle: CGFloat, spread: CGFloat) {
        guard let parent = parent else {
            return
        }

        let locations = [
            parent.convert(CGPoint(x: radius / 2, y: radius / 2), from: self),
            parent.convert(CGPoint(x: radius / 2, y:-radius / 2), from: self),
            parent.convert(CGPoint(x:-radius / 2, y: radius / 2), from: self),
            parent.convert(CGPoint(x:-radius / 2, y:-radius / 2), from: self),
        ]
        4.times { (i: Int) in
            let node = ShrapnelNode(type: .Enemy(enemyType(), health: 100), size: .Big)
            node.setupAround(node: self, at: locations[i])
            let dest = CGPoint(r: rand(min: dist, max: dist * 1.5), a: angle ± rand(spread))
            node.moveToComponent?.target = node.position + dest
            parent << node
        }
    }

    func generateBulletShrapnel(damage: Float) {
        guard let parent = parent else { return }

        Int(damage * 10).times {
            let node = ShrapnelNode(type: .Enemy(enemyType(), health: 100), size: .Small)
            node.setupAround(node: self)
            parent << node
        }
    }

}

extension EnemySoldierNode {

    func runAway() {
        self.get(component: FollowComponent.self)?.removeFromNode()
        let angle: CGFloat = zRotation + TAU_2 ± rand(TAU_4)
        let dist: CGFloat = rand(min: 15, max: 30)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func dodge() {
        self.get(component: FollowComponent.self)?.removeFromNode()
        let angle: CGFloat = zRotation ± (TAU_4 - 10.degrees)
        let dist: CGFloat = rand(min: 20, max: 40)
        let dest = position + CGPoint(r: dist, a: angle)
        self.rammingComponent?.enabled = true
        self.rammingComponent?.tempTarget = dest
    }

    func follow(leader: Node, scatter: Scatter = .RunAway, component: FollowComponent? = nil) {
        let followComponent = component ?? self.get(component: FollowComponent.self) ?? FollowNodeComponent()

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
            if let `self` = self {
                self.rammingComponent?.currentSpeed = leader.rammingComponent?.currentSpeed ?? 0
                self.rammingComponent?.currentTarget = leader.rammingComponent?.currentTarget
                self.playerTargetingComponent?.currentTarget = leader.playerTargetingComponent?.currentTarget
                self.playerTargetingComponent?.targetingEnabled = true
                self.get(component: FollowComponent.self)?.removeFromNode()
            }
        }
        addComponent(followComponent)
    }

}
