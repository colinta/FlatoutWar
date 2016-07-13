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

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let node = PulseNode()
        playerNode << node

        level.timeline.after(PulseNode.MaxTime, block: completion)
        powerupRunning()
    }

}
