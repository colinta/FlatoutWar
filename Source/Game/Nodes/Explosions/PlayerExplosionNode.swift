//
//  PlayerExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let numSprites = 50
private let maxDistance: CGFloat = 30
private let duration: CGFloat = 3
private let maxLength: CGFloat = 60

class PlayerExplosionNode: Node {
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .Bottom

        for _ in 0..<numSprites {
            let sprite = SKSpriteNode(id: .None)
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

        let amt = Int(round(interpolate(phase, from: (0, 1), to: (0xff, 0))))
        let color = hex(r: amt, g: amt, b: amt)
        let distance = phase * maxDistance
        let length = min(4 * distance, maxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerate() {
            let angle = (phase * TAU) + CGFloat(i) / CGFloat(sprites.count) * TAU
            sprite.textureId(.ColorLine(length: length, color: color))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
