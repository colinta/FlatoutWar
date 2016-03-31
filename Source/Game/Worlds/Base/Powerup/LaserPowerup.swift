//
//  LaserPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var weight: Weight { return .Special }
    override var count: Int { return 2 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Laser }

    required override init() {
        super.init()
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let angle = position.angle
            var maxDelay: CGFloat = 0
            15.times { (i: Int) in
                let delay: CGFloat = CGFloat(i) * rand(min: 0.2, max: 0.4)
                maxDelay = delay
                let offset = CGPoint(r: CGFloat(5), a: rand(TAU))
                level.timeline.after(delay) {
                    let laser = LaserBeamNode(angle: angle ± rand(2.degrees))
                    laser.position = playerNode.position + offset
                    level << laser
                }
            }
            level.timeline.after(maxDelay, block: completion)
        }
    }

}
