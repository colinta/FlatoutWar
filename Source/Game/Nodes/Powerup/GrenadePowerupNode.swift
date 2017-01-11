////
///  GrenadePowerupNode.swift
//

class GrenadePowerupNode: Node {

    required init() {
        super.init()

        let sprite = SKSpriteNode(id: .Powerup(type: .Grenade))
        self << sprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
