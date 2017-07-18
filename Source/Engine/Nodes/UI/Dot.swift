////
///  Dot.swift
//

class Dot: Node {
    let sprite = SKSpriteNode(id: .dot(color: 0x808080))

    required init() {
        super.init()
        self << sprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
