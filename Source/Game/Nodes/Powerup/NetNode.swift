////
///  NetNode.swift
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

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func update(_ dt: CGFloat) {
        sprite.textureId(.Net(phase: Int(phaseComponent!.phase * 100)))

        if let world = world {
            let scaledRadius = radius * self.xScale
            for enemy in world.enemies where
                enemy.enemyComponent!.targetable
                && !netted.contains(enemy)
                && enemy.distanceTo(self, within: scaledRadius)
            {
                netted << enemy

                let netSprite = SKSpriteNode(id: .EnemyNet(size: 3 * enemy.radius))
                netSprite.z = .Above
                enemy << netSprite

                enemy.addComponent(StoppedComponent())
            }
        }
    }

}
