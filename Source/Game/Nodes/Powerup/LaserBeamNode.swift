////
///  LaserBeamNode.swift
//

private let Length: CGFloat = 70
private let Speed: CGFloat = 150
private let DamageRate: CGFloat = 5

class LaserBeamNode: Node {
    private var currentLength: CGFloat = 0
    private var maxLength: CGFloat = Length
    private(set) var angle: CGFloat = 0
    private let sprite = SKSpriteNode(id: .none)
    private var damaging: Node?

    required init(angle: CGFloat) {
        self.angle = angle
        super.init()

        size = CGSize(2)

        sprite.z = .below
        sprite.anchorPoint = CGPoint(1, 1)
        sprite.zRotation = angle
        self << sprite

        let projectileComponent = ProjectileComponent()
        projectileComponent.intersectionNode = sprite
        projectileComponent.damage = 0
        projectileComponent.onCollision { (enemy, location) in
            self.damaging = enemy
        }
        addComponent(projectileComponent)
    }

    convenience required init() {
        self.init(angle: 0)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ dt: CGFloat) {
        if let enemy = damaging {
            let damage = DamageRate * dt
            enemy.healthComponent?.inflict(damage: Float(damage))
            let rate = Speed / DamageRate
            maxLength -= damage * rate
            if maxLength <= 0 {
                self.removeFromParent()
            }
            damaging = nil
        }
        else {
            currentLength += Speed * dt

            let vector = CGPoint(r: Speed * dt, a: angle)
            self.position += vector
        }

        currentLength = min(currentLength, maxLength)
        sprite.textureId(.colorLine(length: currentLength, color: PowerupRed))
    }

}
