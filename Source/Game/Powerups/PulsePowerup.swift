////
///  PulsePowerup.swift
//

class PulsePowerup: Powerup {
    override var name: String { return "PULSE" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Pulse }
    override var nextResourceCosts: [Int: Int] { return [
        0: 100,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 10
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        let node = PulseNode(at: playerNode.position)
        layer << node

        level.timeline.after(time: PulseNode.MaxTime, block: completion)
        powerupRunning()
    }

}
