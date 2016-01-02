//
//  EnemyExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let numSprites = 25
private let maxDistance: CGFloat = 100
private let duration: CGFloat = 2
private let maxLength: CGFloat = 10

class EnemyExplosionNode: Node {
    private var sprites = [SKSpriteNode]()
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .Bottom
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

    override func populate() {
        for _ in 0..<numSprites {
            let sprite = SKSpriteNode(id: .None)
            sprites << sprite
            self << sprite
        }
    }

    override func update(dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let hue = Int(round(interpolate(phase, from: (0, 1), to: (48, 0))))
        let distance = phase * maxDistance
        let length = min(distance, maxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerate() {
            let angle = CGFloat(i) / CGFloat(sprites.count) * TAU
            let texture = SKTexture.id(.HueLine(length: length, hue: hue))
            sprite.texture = texture
            sprite.size = texture.size() * sprite.xScale
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
