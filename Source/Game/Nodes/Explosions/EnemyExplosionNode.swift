////
///  EnemyExplosionNode.swift
//

private let NumSprites = 25
private let MaxDistance: CGFloat = 100
private let Duration: CGFloat = 2
private let MaxLength: CGFloat = 10

class EnemyExplosionNode: Node {
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .bottom

        for _ in 0..<NumSprites {
            let sprite = SKSpriteNode(id: .none)
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ dt: CGFloat) {
        phase += dt / Duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let hue = Int(round(interpolate(phase, from: (0, 1), to: (48, 0))))
        let distance = phase * MaxDistance
        let length = min(distance, MaxLength)
        let alpha = min(1, 4 * (1 - phase))

        for (i, sprite) in sprites.enumerated() {
            let angle = CGFloat(i) / CGFloat(sprites.count) * TAU
            sprite.textureId(.hueLine(length: length, hue: hue))
            sprite.position = CGPoint(r: distance, a: angle)
            sprite.zRotation = angle
            sprite.alpha = alpha
        }
    }

}
