//
//  ExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let DefaultDistance: CGFloat = 30
private let DefaultDuration: CGFloat = 1

private func radiusToLength(radius: CGFloat) -> CGFloat {
    return max(radius / 10, CGFloat(10))
}

class ExplosionNode: Node {
    static let SmallExplosion: CGFloat = 30
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0
    private var duration: CGFloat
    private var lineLength: CGFloat

    required init(radius: CGFloat = DefaultDistance, duration: CGFloat = DefaultDuration, lineLength: CGFloat? = nil) {
        self.duration = duration
        if let lineLength = lineLength {
            self.lineLength = lineLength
        }
        else {
            self.lineLength = radiusToLength(radius)
        }

        super.init()

        self.size = CGSize(r: radius)
        z = .Bottom

        let numSprites = Int(ceil(radius / 4))
        for _ in 0..<numSprites {
            let sprite = SKSpriteNode(id: .None)
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) {
        let lineLength = coder.decodeCGFloat("lineLength")
        self.lineLength = lineLength ?? 0
        duration = coder.decodeCGFloat("duration") ?? DefaultDuration
        super.init(coder: coder)
        if lineLength == nil {
            self.lineLength = radiusToLength(self.radius)
        }
        phase = coder.decodeCGFloat("phase") ?? 0
        sprites = coder.decode("sprites") ?? []
    }

    convenience required init() {
        self.init(radius: DefaultDistance)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(lineLength, key: "lineLength")
        encoder.encode(duration, key: "duration")
        encoder.encode(phase, key: "phase")
        encoder.encode(sprites, key: "sprites")
    }

    override func update(dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let hue = Int(round(interpolate(phase, from: (0, 1), to: (48, 0))))
        let distance = phase * radius
        let length = min(distance, lineLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerate() {
            let angle = CGFloat(i) / CGFloat(sprites.count) * TAU
            sprite.textureId(.HueLine(length: length, hue: hue))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
