////
///  MinesPowerup.swift
//

class MinesPowerup: Powerup {
    override var name: String { return "MINES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Mines }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let moveDuration: CGFloat = 0.1
            5.times { (i: Int) in
                let a: CGFloat = CGFloat(i) * TAU / 5 ± rand(weighted: TAU_16)
                let r: CGFloat = 17
                let offset = CGPoint(r: r + rand(weighted: 3), a: a)
                let node = MineNode(at: position)
                node.moveTo(position + offset, duration: moveDuration)
                node.scaleTo(1, start: 0, duration: moveDuration)
                layer << node
            }
            level.timeline.after(time: moveDuration) {
                self.slowmo(on: false)
                completion()
            }
        }
    }

}
