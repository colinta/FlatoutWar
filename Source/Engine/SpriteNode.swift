////
///  SpriteNode.swift
//

class SpriteNode: Node {
    let sprite = SKSpriteNode()

    required init(id: ImageIdentifier) {
        super.init()
        sprite.textureId(id)
        size = sprite.size
    }

    required convenience init() {
        self.init(id: .None)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
