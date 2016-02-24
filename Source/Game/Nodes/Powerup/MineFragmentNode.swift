//
//  MineFragmentNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let MaxDistance: CGFloat = 30
private let Duration: CGFloat = 0.5

class MineFragmentNode: Node {
    private var angle: CGFloat
    private var phase: CGFloat = 0
    let sprite = SKSpriteNode(id: .MineExplosion)

    convenience required init() {
        self.init(angle: 0)
    }

    required init(angle: CGFloat) {
        self.angle = angle
        super.init()
        size = CGSize(10)

        sprite.zRotation = angle
        self << sprite

        let projectileComponent = ProjectileComponent()
        projectileComponent.damage = 1
        projectileComponent.intersectionNode = sprite
        projectileComponent.onCollision { (enemy, location) in
            if let world = self.world {
                let absLocation = world.convertPoint(location, fromNode: self)
                let explosionNode = ExplosionNode(radius: ExplosionNode.SmallExplosion)
                explosionNode.position = absLocation
                world << explosionNode
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init?(coder: NSCoder) {
        self.angle = coder.decodeCGFloat("angle") ?? 0
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        phase += dt / Duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let v = MaxDistance / Duration
        let vector = CGPoint(r: v * dt, a: angle)
        position += vector

        let distance = phase * MaxDistance
        let alpha = min(1, 4 * (1 - phase))

        sprite.alpha = alpha
    }

}
