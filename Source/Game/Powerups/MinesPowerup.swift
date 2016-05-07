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

    required override init() {
        super.init()
        self.count = 1
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.slowmo(true)
        self.onNextTap { tapPosition in
            let position: CGPoint
            if tapPosition.distanceTo(playerNode.position, within: 100)
                && !tapPosition.distanceTo(playerNode.position, within: 20)
            {
                position = tapPosition
            }
            else {
                let a = tapPosition.angle
                let r = min(100, max(20, tapPosition.distanceTo(playerNode.position)))
                position = CGPoint(r: r, a: a)
            }

            let moveDuration: CGFloat = 0.1
            5.times { (i: Int) in
                let a: CGFloat = CGFloat(i) * TAU / 5 ± rand(TAU_16)
                let r: CGFloat = 17
                let offset = CGPoint(r: r ± rand(3), a: a)
                let node = MineNode(at: playerNode.position)
                node.moveTo(position + offset, duration: moveDuration)
                level << node
            }
            level.timeline.after(moveDuration) {
                self.slowmo(false)
                completion()
            }
        }
    }

}
