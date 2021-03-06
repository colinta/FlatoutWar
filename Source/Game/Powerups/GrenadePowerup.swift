////
///  GrenadePowerup.swift
//

class GrenadePowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .grenade }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let grenade = GrenadePowerupNode(at: playerNode.position)
            let arcDuration: CGFloat = 0.25
            let length: CGFloat = (position - playerNode.position).length
            let arcToComponent = grenade.arcTo(position, speed: length / arcDuration)
            arcToComponent.onArrived {
                self.slowmo(on: false)
                let bomb = BombNode(maxRadius: 30)
                bomb.position = position
                layer << bomb
            }
            arcToComponent.removeNodeOnArrived()
            grenade.alpha = 0
            grenade.fadeTo(1, duration: arcDuration)

            layer << grenade
            level.timeline.after(time: arcDuration, block: completion)
        }
    }

}
