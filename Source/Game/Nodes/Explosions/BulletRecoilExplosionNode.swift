//
//  BulletRecoilExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let numSprites = 11
private let maxDistance: CGFloat = 25
private let duration: CGFloat = 1.5
private let maxLength: CGFloat = 5

class BulletRecoilExplosionNode: Node {
    private var sprites: [SKSpriteNode] = []
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
            sprite.anchorPoint = CGPoint(0, 0.5)
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
        let length = min(2 * distance, maxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerate() {
            let angle = 135.degrees + 90.degrees * CGFloat(i) / CGFloat(sprites.count - 1)
            sprite.textureId(.HueLine(length: length, hue: hue))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
