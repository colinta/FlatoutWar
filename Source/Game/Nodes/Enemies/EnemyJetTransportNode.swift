////
///  EnemyJetTransportNode.swift
//

private let StartingHealth: Float = 15

class EnemyJetTransportNode: Node {
    var sprite = SKSpriteNode()
    var payload: [Node]?

    required init() {
        super.init()
        size = CGSize(40)

        sprite.z = .Top
        self << sprite

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { _ in
            self.updateTexture()
        }
        healthComponent.onKilled {
            self.generateKilledExplosion()
            self.scaleTo(0, duration: 0.1, removeNode: true)
        }
        addComponent(healthComponent)
        updateTexture()

        let enemyComponent = EnemyComponent()
        enemyComponent.intersectionNode = sprite
        enemyComponent.experience = 0
        enemyComponent.onAttacked { projectile in
            if let damage = projectile.projectileComponent?.damage {
                self.generateShrapnel(damage: damage)
                self.healthComponent?.inflict(damage: damage)
            }
        }
        addComponent(enemyComponent)

        addComponent(RotateToComponent())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    func enemyType() -> ImageIdentifier.EnemyType {
        return .JetTransport
    }

    func updateTexture() {
        sprite.textureId(.Enemy(enemyType(), health: healthComponent?.healthInt ?? 100))
    }

    func transportPayload(_ payload: [Node]) {
        if let prevPayload = self.payload {
            for node in prevPayload {
                node.removeFromParent()
            }
            arcToComponent?.clearOnMoved()
        }

        guard let first = payload.first else { return }

        for node in payload {
            node.active = false
            self << node
        }

        let experience: Int = payload.reduce(0) { $0 + ($1.enemyComponent?.experience ?? 0) }
        if let level = self.world as? Level {
            let prevExperience = enemyComponent!.experience
            level.possibleExperience += (experience - prevExperience)
        }
        enemyComponent!.experience = experience

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

        self.payload = payload
        let dt: CGFloat = 1 / CGFloat(payload.count + 2)
        var timeout: CGFloat = 2 * dt
        arcToComponent?.onMoved { t in
            guard payload.count > 0 else { return }

            while timeout - t < 0 {
                if let node = self.payload?.first,
                    let world = self.world
                {
                    self.enemyComponent?.experience -= node.enemyComponent?.experience ?? 0
                    node.active = true
                    node.move(toParent: world)
                    self.payload?.remove(at: 0)
                }
                else {
                    break
                }
                timeout += dt
            }
        }
    }

    func generateKilledExplosion() {
        guard let parent = parent else { return }

        let explosion = EnemyExplosionNode(at: self.position)
        parent << explosion
        self.generateBigShrapnel(distance: 10, angle: 0, spread: TAU)
    }

    func generateBigShrapnel(distance dist: CGFloat, angle: CGFloat, spread: CGFloat) {
        guard let parent = parent else { return }

        let node = ShrapnelNode(type: .Enemy(enemyType(), health: 100), size: .Actual)
        node.setupAround(node: self, at: self.position,
            rotateSpeed: rand(min: 5, max: 8),
            distance: rand(10)
            )
        parent << node
    }

    func generateShrapnel(damage: Float) {
        guard let parent = parent else { return }

        Int(damage * 10).times {
            let node = ShrapnelNode(type: .Enemy(enemyType(), health: 100), size: .Small)
            node.setupAround(node: self)
            parent << node
        }
    }

}
