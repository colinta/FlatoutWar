////
///  SoldiersPowerup.swift
//

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Soldiers }
    override var nextResourceCosts: [Int: Int] { return [
        0: 40,
        1: 80,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 30
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let numSoldiers = 4
        numSoldiers.times { (i: Int) in
            let angle = TAU / CGFloat(numSoldiers) * CGFloat(i) ± rand(TAU_8)
            let dest = CGPoint(r: 60, a: angle)
            let node = SoldierNode()
            node.restingPosition = dest
            node.rotateTo(angle)
            node.moveTo(dest, duration: 1)
            node.fadeTo(1, start: 0, duration: 1)
            playerNode << node
        }

        completion()
        powerupRunning()
    }

}
