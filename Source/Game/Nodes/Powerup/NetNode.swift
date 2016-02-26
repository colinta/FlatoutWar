//
//  NetNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/24/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NetNode: Node {
    let sprite = SKSpriteNode(id: .Net(phase: 0))
    var netted: [Node] = []

    required init() {
        super.init()
        size = sprite.size
        self << sprite

        let phase = PhaseComponent()
        phase.loops = true
        phase.duration = 1.667
        addComponent(phase)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        sprite.textureId(.Net(phase: Int(phaseComponent!.phase * 100)))

        if let world = world {
            let scaledRadius = radius * self.xScale
            for enemy in world.enemies {
                if enemy.enemyComponent!.targetable && !netted.contains(enemy) && enemy.distanceTo(self, within: scaledRadius) {
                    netted << enemy

                    let netSprite = SKSpriteNode(id: .EnemyNet(size: 2.25 * enemy.radius))
                    netSprite.zPosition = Z.Above.rawValue
                    enemy << netSprite

                    enemy.addComponent(StoppedComponent())
                }
            }
        }
    }

}
