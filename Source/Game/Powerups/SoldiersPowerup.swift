//
//  SoldiersPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/16/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Soldiers }

    required override init() {
        super.init()
        self.count = nil
        self.timeout = 30
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let position = playerNode.position
        let numSoldiers = 4
        numSoldiers.times { (i: Int) in
            let angle = TAU / CGFloat(numSoldiers) * CGFloat(i) ± rand(TAU_8)
            let dest = position + CGPoint(r: 60, a: angle)
            let node = SoldierNode(at: position)
            node.restingPosition = dest
            node.rotateTo(angle)
            node.moveTo(dest, duration: 1)
            node.fadeTo(1, start: 0, duration: 1)
            level << node
        }

        completion()
    }

}
