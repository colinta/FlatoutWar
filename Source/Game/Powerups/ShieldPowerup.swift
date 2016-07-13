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

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let node = ShieldNode()
        node.scaleTo(1, start: 0, duration: 1)
        node.fadeTo(1, start: 0, duration: 1)
        playerNode << node
        completion()
        powerupRunning()
    }

}
