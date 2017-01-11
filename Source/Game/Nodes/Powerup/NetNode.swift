////
///  NetNode.swift
//

class NetNode: Node {
    let sprite = SKSpriteNode(id: .Net(phase: 0))
    var netted: [Node] = []
    let phaseComponent = PhaseComponent()

    required init() {
        super.init()
        size = sprite.size
        self << sprite

        phaseComponent.loops = true
        phaseComponent.duration = 1.667
        addComponent(phaseComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ dt: CGFloat) {
        sprite.textureId(.Net(phase: Int(phaseComponent.phase * 100)))

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
