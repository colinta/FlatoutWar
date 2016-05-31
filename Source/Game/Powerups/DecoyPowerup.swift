//
//  DecoyPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DecoyPowerup: Powerup {
    override var name: String { return "DECOY" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Decoy }
    override var resourceCost: Int { return 5 }

    required override init() {
        super.init()
        self.count = 2
        self.timeout = 2
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let decoy = DecoyPowerupNode(at: playerNode.position)
            decoy.alpha = 0
            level << decoy
            decoy.moveTo(position, duration: 1)
            decoy.fadeTo(1, duration: 1)
            completion()
        }
    }

}
