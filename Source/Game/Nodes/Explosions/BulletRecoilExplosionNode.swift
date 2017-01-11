////
///  BulletRecoilExplosionNode.swift
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

        for _ in 0..<numSprites {
            let sprite = SKSpriteNode(id: .None)
            sprite.anchorPoint = CGPoint(0, 0.5)
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let hue = Int(round(interpolate(phase, from: (0, 1), to: (48, 0))))
        let distance = phase * maxDistance
        let length = min(2 * distance, maxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerated() {
            let angle = 135.degrees + 90.degrees * CGFloat(i) / CGFloat(sprites.count - 1)
            sprite.textureId(.HueLine(length: length, hue: hue))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
