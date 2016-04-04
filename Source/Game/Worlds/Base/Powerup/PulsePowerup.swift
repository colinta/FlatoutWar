//
//  PulsePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PulsePowerup: Powerup {
    override var name: String { return "PULSE" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Pulse }

    required override init() {
        super.init()
        self.count = 2
        self.timeout = 10
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let position = playerNode.position
        let node = PulseNode(at: position)
        level << node

        level.timeline.after(PulseNode.MaxTime, block: completion)
    }

}
