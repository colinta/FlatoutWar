//
//  MineNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class MineNode: Node {
    let sprite = SKSpriteNode(id: .Mine)

    required init() {
        super.init()
        size = CGSize(15)
        self << sprite

        let projectileComponent = ProjectileComponent()
        projectileComponent.damage = 10
        projectileComponent.intersectionNode = sprite
        projectileComponent.onCollision { (enemy, location) in
            if let world = self.world {
                let absLocation = world.convertPoint(location, fromNode: self)
                let explosionNode = MineFragmentNode(at: absLocation)
                world << explosionNode
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
