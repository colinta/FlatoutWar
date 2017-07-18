////
///  GrenadePowerupNode.swift
//

class GrenadePowerupNode: Node {

    required init() {
        super.init()

        let sprite = SKSpriteNode(id: .powerup(type: .grenade))
        self << sprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
