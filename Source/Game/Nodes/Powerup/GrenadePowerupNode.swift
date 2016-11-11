////
///  GrenadePowerupNode.swift
//

class GrenadePowerupNode: Node {

    required init() {
        super.init()

        let sprite = SKSpriteNode(id: .Powerup(type: .Grenade))
        self << sprite
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

}
