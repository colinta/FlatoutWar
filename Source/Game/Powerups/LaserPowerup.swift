////
///  LaserPowerup.swift
//

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Laser }
    override var nextResourceCosts: [Int: Int] { return [
        0: 20,
        1: 40,
        2: 80,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 30
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: Block = {}) {
        super.activate(level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let angle = position.angle
            15.times { (i: Int) in
                let delay: CGFloat = CGFloat(i) * rand(min: 0.2, max: 0.4)
                let offset = CGPoint(r: CGFloat(5), a: rand(TAU))
                level.timeline.after(delay) {
                    let laser = LaserBeamNode(angle: angle ± rand(2.degrees))
                    laser.position = playerNode.position + offset
                    layer << laser
                }
            }
            completion()
        }
    }

}
