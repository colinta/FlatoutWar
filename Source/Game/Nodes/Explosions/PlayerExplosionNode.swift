//
//  PlayerExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let numSprites = 20
private let maxDistance: CGFloat = 30
private let duration: CGFloat = 3
private let maxLength: CGFloat = 60

class PlayerExplosionNode: Node {
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .Bottom

        for index in 0..<numSprites {
            let sprite = SKSpriteNode(id: .BaseExplosion(index: index, total: numSprites))
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        phase = coder.decodeCGFloat("phase") ?? 0
        sprites = coder.decode("sprites") ?? []
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(phase, key: "phase")
        encoder.encode(sprites, key: "sprites")
    }

    override func update(dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let distance = easeOutCubic(time: phase, final: maxDistance)
        let alpha = easeOutCubic(time: phase, initial: 1, final: 0)

        for (i, sprite) in sprites.enumerate() {
            let angle = TAU / CGFloat(sprites.count) * CGFloat(i)
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.alpha = alpha
        }
    }

}
