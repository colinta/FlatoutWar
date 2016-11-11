////
///  EnemyAttackExplosionNode.swift
//

private let numSprites = 5
private let maxDistance: CGFloat = 40
private let duration: CGFloat = 0.4
private let maxLength: CGFloat = 35

class EnemyAttackExplosionNode: Node {
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .Bottom

        for _ in 0..<numSprites {
            let sprite = SKSpriteNode(id: .None)
            sprite.anchorPoint = CGPoint(0, 0.5)
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        phase = coder.decodeCGFloat(key: "phase") ?? 0
        sprites = coder.decode(key: "sprites") ?? []
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(phase, forKey: "phase")
        encoder.encode(sprites, forKey: "sprites")
    }

    override func update(_ dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let amt = Int(round(interpolate(phase, from: (0, 1), to: (0, 0xff))))
        let color = hex(r: amt, g: amt, b: 0xff)
        let distance = phase * maxDistance
        let length = min(distance, maxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerated() {
            let angle = 175.degrees + 10.degrees * CGFloat(i) / CGFloat(sprites.count - 1)
            sprite.textureId(.ColorLine(length: length, color: color))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
