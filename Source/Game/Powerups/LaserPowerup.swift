//
//  LaserPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Laser }
    override var resourceCost: Int { return 10 }

    required override init() {
        super.init()
        self.count = nil
        self.timeout = 30
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let angle = position.angle
            15.times { (i: Int) in
                let delay: CGFloat = CGFloat(i) * rand(min: 0.2, max: 0.4)
                let offset = CGPoint(r: CGFloat(5), a: rand(TAU))
                level.timeline.after(delay) {
                    let laser = LaserBeamNode(angle: angle ± rand(2.degrees))
                    laser.position = playerNode.position + offset
                    level << laser
                }
            }
            completion()
        }
    }

}
