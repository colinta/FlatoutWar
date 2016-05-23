//
//  ShieldPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ShieldPowerup: Powerup {
    override var name: String { return "SHIELD" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Shield }

    required override init() {
        super.init()
        self.count = 1
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let position = playerNode.position
        let node = ShieldNode(at: position)
        node.scaleTo(1, start: 0, duration: 1)
        node.fadeTo(1, start: 0, duration: 1)
        level << node
        completion()
        powerupRunning()
    }

}
