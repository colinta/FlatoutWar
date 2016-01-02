//
//  BulletNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BulletNode: Node {
    var damage = Float(10) { didSet { projectileComponent?.damage = damage } }

    enum Style {
        case Fast
        case Slow
    }

    required init(velocity: CGPoint, style: Style) {
        super.init()

        self << SKSpriteNode(id: .BaseTurretBullet(upgrade: .One))
        size = BaseTurretBulletArtist.bulletSize(.One)

        addComponent(KeepMovingComponent(velocity: velocity))

        let projectileComponent = ProjectileComponent()
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


class BulletArtist: Artist {
    var color = UIColor(hex: 0x9F0025)
    var upgrade = FiveUpgrades.Default

    static func bulletSize(upgrade: FiveUpgrades) -> CGSize {
        switch upgrade {
        case .One:
            return CGSize(width: 2, height: 2)
        case .Two:
            return CGSize(width: 2.5, height: 1.6)
        case .Three:
            return CGSize(width: 3, height: 1.333)
        case .Four:
            return CGSize(width: 3.5, height: 1.142)
        case .Five:
            return CGSize(width: 4, height: 0.25)
        }
    }

    override func draw(context: CGContext) {
        let r = size.width / 2
        let bulletSize = r * BulletArtist.bulletSize(upgrade)

        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        if bulletSize.width == bulletSize.height {
            CGContextAddEllipseInRect(context, CGRect(origin: CGPointZero, size: size))
            CGContextDrawPath(context, .Fill)
        }
        else {
            let r = bulletSize.height / 2
            CGContextMoveToPoint(context, middle.x - bulletSize.width / 2  + r, middle.y - r)
            CGContextAddArc(context, middle.x + bulletSize.width / 2 - r, middle.y, r, -TAU_4, TAU_4, 0)
            CGContextAddArc(context, middle.x - bulletSize.width / 2  + r, middle.y, r, TAU_4, -TAU_4, 0)
            CGContextDrawPath(context, .Fill)
        }
    }

}
