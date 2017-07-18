////
///  WoodsBossNode.swift
//

private let FootStartingHealth: Float = 10
private let BodyStartingHealth: Float = 15
private let Experience = 62

class WoodsBossNode: Node {
    var bodyL: [Node] = []
    var bodyR: [Node] = []
    let phaseComponent = PhaseComponent()

    required init() {
        super.init()

        name = "woods boss"
        size = CGSize(width: 123, height: 70)

        let enemyComponent = EnemyComponent()
        enemyComponent.experience = Experience
        addComponent(enemyComponent)

        let health: Float = 1
        let healthComponent = HealthComponent(health: health)
        addComponent(healthComponent)

        let dx: CGFloat = 31
        let xs: [CGFloat] = [0, 1 * dx, 2 * dx, 3 * dx]
        let bodyDeath = after(xs.count) {
            healthComponent.inflict(damage: health)
            self.removeFromParent()
        }

        for x in xs {
            let body = WoodsBossBodyNode(at: CGPoint(x, 0))
            body.onDeath(bodyDeath)
            self << body

            if bodyL.count < bodyR.count {
                bodyL << body
            }
            else {
                bodyR << body
            }
        }

        let targetingComponent = PlayerTargetingComponent()
        targetingComponent.onTargetAcquired { target in
            if let target = target {
                self.rotateTowards(target)
            }
        }
        addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.maxSpeed = 10
        addComponent(rammingComponent)

        phaseComponent.duration = 6
        phaseComponent.loops = true
        addComponent(phaseComponent)
    }

    override func update(_ dt: CGFloat) {
        let angle = 10.degrees * CGFloat(sin(phaseComponent.phase * TAU))
        let speed = CGFloat(abs(10 * cos(phaseComponent.phase * TAU)))
        rammingComponent?.maxSpeed = speed

        for body in bodyL {
            body.zRotation = angle
        }
        for body in bodyR {
            body.zRotation = -angle
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

class WoodsBossBodyNode: Node {
    let sprite = SKSpriteNode()

    func updateTexture() {
        sprite.textureId(.woodsBossBody(health: healthComponent?.healthInt ?? 100))
    }

    required init() {
        super.init()

        name = "woods boss body"
        size = CGSize(30)

        let dy: CGFloat = 40
        let line = SpriteNode(id: .colorLine(length: 2 * dy, color: 0xFFFFFF))
        let foot1 = WoodsBossFootNode(at: CGPoint(0, -dy))
        let foot2 = WoodsBossFootNode(at: CGPoint(0, dy))
        line.zRotation = TAU_4
        line.z = .below
        self << line
        self << foot1
        self << foot2

        var deadFeet = 0
        foot1.onDeath {
            deadFeet += 1
        }
        foot2.onDeath {
            deadFeet += 1
        }

        self << sprite
        sprite.lightingBitMask   = 0xFFFFFFFF
        sprite.shadowCastBitMask = 0xFFFFFFFF

        let healthComponent = HealthComponent(health: BodyStartingHealth)
        healthComponent.onHurt { _ in
            self.onHurt()
        }
        healthComponent.onKilled(self.onKilled)
        addComponent(healthComponent)
        updateTexture()

        let enemyComponent = EnemyComponent()
        enemyComponent.intersectionNode = sprite
        enemyComponent.onAttacked { projectile in
            guard deadFeet == 2 else { return }

            if let damage = projectile.projectileComponent?.damage {
                self.healthComponent?.inflict(damage: damage)
            }
        }
        addComponent(enemyComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.onRammed(self.onRammed)
        addComponent(rammingComponent)

        addComponent(RotateToComponent())
    }

    func onHurt() {
        _ = world?.channel?.play(Sound.EnemyHurt)
        updateTexture()
    }

    func onKilled() {
        self.scaleTo(0, duration: 0.1, removeNode: true)
    }

    func onRammed(player: Node) {
        if let healthComponent = player.healthComponent {
            healthComponent.inflict(damage: healthComponent.health)
        }

        rammingComponent?.enabled = false
        scaleTo(0, duration: 0.1, removeNode: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class WoodsBossFootNode: Node {
    let sprite = SKSpriteNode()

    func updateTexture() {
        sprite.textureId(.woodsBossFoot(health: healthComponent?.healthInt ?? 100))
    }

    required init() {
        super.init()

        name = "woods boss foot"
        size = CGSize(20)

        self << sprite
        sprite.lightingBitMask   = 0xFFFFFFFF
        sprite.shadowCastBitMask = 0xFFFFFFFF

        let healthComponent = HealthComponent(health: FootStartingHealth)
        healthComponent.onHurt { _ in
            self.onHurt()
        }
        healthComponent.onKilled(self.onKilled)
        addComponent(healthComponent)
        updateTexture()

        let enemyComponent = EnemyComponent()
        enemyComponent.intersectionNode = sprite
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.healthComponent?.inflict(damage: damage)
            }
        }
        addComponent(enemyComponent)
    }

    func onHurt() {
        _ = world?.channel?.play(Sound.EnemyHurt)
        updateTexture()
    }

    func onKilled() {
        self.scaleTo(0, duration: 0.1, removeNode: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
