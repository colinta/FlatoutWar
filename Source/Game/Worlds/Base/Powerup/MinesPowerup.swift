//
//  MinesPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class MinesPowerup: Powerup {
    override var name: String { return "MINES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Mines }
    override var count: Int { return 3 }

    required override init() {
        super.init()
    }

    override func activate(level: BaseLevel) {
        super.activate(level)

        self.onNextTap(slowmo: true) { position in
            5.times { (i: Int) in
                let a: CGFloat = CGFloat(i) * TAU / 5 ± rand(TAU_16)
                let r: CGFloat = 17
                let offset = CGPoint(r: r ± rand(3), a: a)
                let node = MineNode(at: level.playerNode.position)
                node.moveTo(position + offset, duration: 1)
                level << node
            }
        }
    }

}
