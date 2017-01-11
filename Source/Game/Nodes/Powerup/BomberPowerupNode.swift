////
///  BomberPowerupNode.swift
//

private let initialBombCount = 8

class BomberPowerupNode: Node {
    var numBombs = initialBombCount
    let sprite: SKSpriteNode = SKSpriteNode(id: .Bomber(numBombs: 8))
    let followPathComponent = FollowPathComponent()
    var bombs: [Node] = []
    override var timeRate: CGFloat {
        didSet {
            for node in bombs {
                node.timeRate = timeRate
            }
        }
    }

    required init() {
        super.init()
        size = CGSize(50)

        sprite.z = .Top
        self << sprite

        followPathComponent.velocity = 150
        addComponent(followPathComponent)

        let rotateComponent = RotateToComponent()
        rotateComponent.maxAngularSpeed = 15
        rotateComponent.angularAccel = nil
        addComponent(rotateComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func rotateTo(_ angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func update(_ dt: CGFloat) {
        let timeChunk = followPathComponent.totalTime / (CGFloat(initialBombCount) - 1)
        let timeCheck = timeChunk * CGFloat(initialBombCount - numBombs)
        if followPathComponent.time >= timeCheck {
            dropBomb()
        }
    }

    private func dropBomb() {
        guard numBombs > 0 else { return }

        if let world = world {
            let bomb = BombNode(maxRadius: 50)
            bomb.damage = 4
            bomb.position = world.convertPosition(self)
            bomb.timeRate = timeRate
            bombs << bomb
            world << bomb

            numBombs -= 1
            sprite.textureId(.Bomber(numBombs: numBombs))
        }
    }

}
