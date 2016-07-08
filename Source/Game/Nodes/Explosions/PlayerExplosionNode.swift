////
///  PlayerExplosionNode.swift
//

private let numSprites = 20
private let maxDistance: CGFloat = 40
private let duration: CGFloat = 3
private let maxLength: CGFloat = 60

class PlayerExplosionNode: Node {
    private var sprites: [(SKSpriteNode, CGFloat, CGFloat)] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        z = .Bottom

        for index in 0..<numSprites {
            let sprite = SKSpriteNode(id: .BaseExplosion(index: index, total: numSprites))
            sprite.zPosition = zPosition
            sprites << (sprite, (±rand(30...90)).degrees, maxDistance * rand(min: 0.1, max: 1))
            self << sprite
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(dt: CGFloat) {
        phase += dt / duration
        guard phase <= 1 else {
            return
        }

        let distance = easeOutCubic(time: phase)
        let alpha = easeOutCubic(time: phase, initial: 1, final: 0.25)

        for (i, (sprite, rotation, maxDistance)) in sprites.enumerate() {
            let angle = TAU / CGFloat(sprites.count) * CGFloat(i)
            sprite.position = CGPoint(r: distance * maxDistance, a: angle)
            sprite.alpha = alpha
            sprite.zRotation = rotation * distance
        }
    }

}
