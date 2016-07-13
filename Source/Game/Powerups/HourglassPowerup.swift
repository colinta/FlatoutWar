////
///  HourglassPowerup.swift
//

let HourglassSize: CGFloat = 225

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

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        powerupEnabled = false
        let hourglass = HourglassNode()
        playerNode << hourglass

        hourglass.onDeath {
            self.powerupEnabled = true
            completion()
        }

        powerupRunning()
    }

}
