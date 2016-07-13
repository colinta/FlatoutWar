////
///  GrenadePowerup.swift
//

class GrenadePowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Grenade }
    override var nextResourceCosts: [Int: Int] { return [
        0: 10,
        1: 20,
        2: 40,
        3: 60,
        4: 80,
    ] }

    required init(count: Int) {
        super.init(count: count)
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let grenade = GrenadePowerupNode(at: playerNode.position)
            let arcDuration: CGFloat = 0.25
            let length: CGFloat = (position - playerNode.position).length
            let arcToComponent = grenade.arcTo(position, speed: length / arcDuration)
            arcToComponent.onArrived {
                self.slowmo(false)
                let bomb = BombNode(maxRadius: 30)
                bomb.position = position
                playerNode << bomb
            }
            arcToComponent.removeNodeOnArrived()
            grenade.alpha = 0
            grenade.fadeTo(1, duration: arcDuration)

            playerNode << grenade
            level.timeline.after(arcDuration, block: completion)
        }
    }

}
