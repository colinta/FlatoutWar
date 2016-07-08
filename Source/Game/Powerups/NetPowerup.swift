////
///  NetPowerup.swift
//

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Net }
    override var resourceCost: Int { return 10 }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let node = NetNode(at: position)
            node.scaleTo(1, start: 0, duration: 0.8, easing: .EaseOutElastic)
            level << node

            level.timeline.after(1) {
                node.fadeTo(0, duration: 1, removeNode: true)
                self.slowmo(false)
                completion()
            }
        }
    }

}
