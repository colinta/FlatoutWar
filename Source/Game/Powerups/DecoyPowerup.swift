////
///  DecoyPowerup.swift
//

class DecoyPowerup: Powerup {
    override var name: String { return "DECOY" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Decoy }
    override var nextResourceCosts: [Int: Int] { return [
        0: 10,
        1: 20,
        2: 40,
        3: 60,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 2
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: Block = {}) {
        super.activate(level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let decoy = DecoyPowerupNode(at: playerNode.position)
            decoy.moveTo(position, duration: 1)
            decoy.fadeTo(1, start: 0, duration: 1)
            layer << decoy
            completion()
        }
    }

}
