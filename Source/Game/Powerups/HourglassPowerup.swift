////
///  HourglassPowerup.swift
//

let HourglassSize: CGFloat = 400

class HourglassPowerup: Powerup {
    override var name: String { return "HOURGLASS" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Hourglass }
    override var nextResourceCosts: [Int: Int] { return [
        0: 10,
        1: 20,
        2: 40,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 10
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        powerupEnabled = false
        let hourglass = HourglassNode(at: playerNode.position)
        layer << hourglass

        hourglass.onDeath {
            self.powerupEnabled = true
            completion()
        }

        powerupRunning()
    }

}
