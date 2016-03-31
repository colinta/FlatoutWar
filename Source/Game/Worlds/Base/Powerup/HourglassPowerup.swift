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
    override var weight: Weight { return .Special }
    override var count: Int { return 2 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Hourglass }

    required override init() {
        super.init()
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
    }

}
