//
//  SoldiersPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/16/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    override var count: Int { return 3 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Soldiers }

    required override init() {
        super.init()
    }

    override func activate(level: BaseLevel) {
        super.activate(level)

        let position = level.playerNode.position
        1.times { (i: Int) in
            let angle = TAU / 9 * CGFloat(i)
            let dest = position + CGPoint(r: 60, a: angle)
            let node = SoldierNode(at: position)
            node.rotateTo(angle)
            node.moveTo(dest, duration: 1)
            node.fadeTo(1, start: 0, duration: 1)
            level << node
        }
    }

}
