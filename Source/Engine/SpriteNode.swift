////
///  SpriteNode.swift
//

class SpriteNode: Node {
    private let sprite = SKSpriteNode()
    var anchorPoint: CGPoint {
        get { return sprite.anchorPoint }
        set { sprite.anchorPoint = newValue }
    }
    override var zPosition: CGFloat {
        didSet { sprite.zPosition = zPosition }
    }

    required init(id: ImageIdentifier) {
        super.init()

        textureId(id)
        self << sprite
    }

    func textureId(_ spriteId: ImageIdentifier, scale: Artist.Scale = .Default) {
        sprite.textureId(spriteId, scale: scale)
        size = spriteId.artist.size
    }

    required convenience init() {
        self.init(id: .None)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
