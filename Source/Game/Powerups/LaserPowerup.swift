////
///  LaserPowerup.swift
//

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Laser }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 30
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let angle = position.angle
            15.times { (i: Int) in
                let delay: CGFloat = CGFloat(i) * rand(min: 0.2, max: 0.4)
                let offset = CGPoint(r: CGFloat(5), a: rand(TAU))
                level.timeline.after(time: delay) {
                    let laser = LaserBeamNode(angle: angle ± rand(2.degrees))
                    laser.position = playerNode.position + offset
                    layer << laser
                }
            }
            completion()
        }
    }

}
