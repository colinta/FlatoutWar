////
///  SoldiersPowerup.swift
//

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    override var powerupType: ImageIdentifier.PowerupType? { return .soldiers }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 30
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let numSoldiers = 4
            numSoldiers.times { (i: Int) in
                let angle = TAU / CGFloat(numSoldiers) * CGFloat(i) ± rand(TAU_8)
                let dest = position + CGPoint(r: 60, a: angle)
                let node = SoldierNode(at: position)
                node.restingPosition = dest
                node.setRotation(angle)
                node.moveTo(dest, duration: 1)
                node.fadeTo(1, start: 0, duration: 1)
                layer << node
            }

            completion()
        }
    }

}
