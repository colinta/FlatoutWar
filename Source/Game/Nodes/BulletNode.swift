////
///  BulletNode.swift
//

class BulletNode: Node {
    var damage: Float = 10 { didSet { projectileComponent?.damage = damage } }
    let sprite = SKSpriteNode()

    enum Style {
        case Fast
        case Slow
    }

    required init(velocity: CGPoint, style: Style) {
        super.init()

        sprite.textureId(.Bullet(upgrade: .False, style: style))
        self << sprite
        size = BulletArtist.bulletSize(.False)

        addComponent(KeepMovingComponent(velocity: velocity))

        let projectileComponent = ProjectileComponent()
        projectileComponent.intersectionNode = sprite
        projectileComponent.damage = damage
        projectileComponent.onCollision { (enemy, location) in
            if let world = self.world {
                let absLocation = world.convertPoint(location, fromNode: self)
                let a = velocity.angle
                let explosionNode = BulletRecoilExplosionNode(at: absLocation)
                explosionNode.zRotation = a
                world << explosionNode
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
