//
//  HourglassPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

let HourglassSize: CGFloat = 225

class HourglassPowerup: Powerup {
    override var name: String { return "HOURGLASS" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Hourglass }
    override var resourceCost: Int { return 5 }

    required override init() {
        super.init()
        self.count = 2
        self.timeout = 10
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        powerupEnabled = false
        let player = playerNode
        let hourglass = HourglassNode(at: player.position)
        hourglass.setScale(0)
        level << hourglass

        hourglass.onDeath {
            self.powerupEnabled = true
            completion()
        }

        powerupRunning()
    }

}
