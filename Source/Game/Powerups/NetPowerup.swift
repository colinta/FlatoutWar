////
///  NetPowerup.swift
//

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Net }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let node = NetNode(at: position)
            node.scaleTo(1, start: 0, duration: 0.8, easing: .EaseOutElastic)
            layer << node

            level.timeline.after(time: 1) {
                node.fadeTo(0, duration: 1, removeNode: true)
                self.slowmo(on: false)
                completion()
            }
        }
    }

}
