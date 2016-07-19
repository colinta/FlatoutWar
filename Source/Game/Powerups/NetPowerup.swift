////
///  NetPowerup.swift
//

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Net }
    override var nextResourceCosts: [Int: Int] { return [
        0: 30,
        1: 60,
        2: 120,
    ] }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: Block = {}) {
        super.activate(level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let node = NetNode(at: position)
            node.scaleTo(1, start: 0, duration: 0.8, easing: .EaseOutElastic)
            layer << node

            level.timeline.after(1) {
                node.fadeTo(0, duration: 1, removeNode: true)
                self.slowmo(false)
                completion()
            }
        }
    }

}
