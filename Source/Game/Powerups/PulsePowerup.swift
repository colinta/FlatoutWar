////
///  PulsePowerup.swift
//

class PulsePowerup: Powerup {
    override var name: String { return "PULSE" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Pulse }
    override var resourceCost: Int { return 15 }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 10
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let position = playerNode.position
        let node = PulseNode(at: position)
        level << node

        level.timeline.after(PulseNode.MaxTime, block: completion)
        powerupRunning()
    }

}
