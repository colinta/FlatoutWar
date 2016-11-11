////
///  ShieldPowerup.swift
//

class ShieldPowerup: Powerup {
    override var name: String { return "SHIELD" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Shield }
    override var nextResourceCosts: [Int: Int] { return [
        0: 100,
    ] }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        let node = ShieldNode(at: playerNode.position)
        node.scaleTo(1, start: 0, duration: 1)
        node.fadeTo(1, start: 0, duration: 1)
        layer << node
        completion()
        powerupRunning()
    }

}
