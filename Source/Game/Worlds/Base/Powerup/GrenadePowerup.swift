//
//  GrenadePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/16.
//  Copyright © 2016 colinta. All rights reserved.
//

class GrenadePowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var count: Int { return 4 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Grenade }

    required override init() {
        super.init()
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        slowmo(true)
        self.onNextTap { position in
            let grenade = GrenadePowerupNode(at: playerNode.position)
            let arcDuration: CGFloat = 0.1
            let arcToComponent = grenade.arcTo(position, duration: arcDuration)
            arcToComponent.onArrived {
                self.slowmo(false)
                let bomb = BombNode(maxRadius: 40)
                bomb.position = position
                level << bomb
            }
            arcToComponent.removeNodeOnArrived()
            grenade.alpha = 0
            grenade.fadeTo(1, duration: arcDuration)

            level << grenade
            level.timeline.after(arcDuration, block: completion)
        }
    }

}
