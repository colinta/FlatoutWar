////
///  BulletNode.swift
//

class BulletNode: Node {
    var damage: Float = 10 { didSet { projectileComponent?.damage = damage } }
    let sprite = SKSpriteNode()

    enum Style {
        case fast
        case slow
    }

    required init(velocity: CGPoint, style: Style) {
        super.init()

        sprite.textureId(.bullet(upgrade: .false, style: style))
        sprite.z = .below
        self << sprite
        size = BulletArtist.bulletSize(upgrade: .false)

        addComponent(KeepMovingComponent(velocity: velocity))

        let projectileComponent = ProjectileComponent()
        projectileComponent.intersectionNode = sprite
        projectileComponent.damage = damage
        projectileComponent.onCollision { (enemy, location) in
            if let parent = self.parent {
                let absLocation = parent.convert(location, from: self)
                let a = velocity.angle
                let explosionNode = BulletRecoilExplosionNode(at: absLocation)
                explosionNode.zRotation = a
                parent << explosionNode
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
