//
//  GrenadePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/16.
//  Copyright © 2016 colinta. All rights reserved.
//

class GrenadePowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Grenade }

    required override init() {
        super.init()
        self.count = 2
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        self.onNextTap(slowmo: true) { position in
            let grenade = GrenadePowerupNode(at: playerNode.position)
            let arcDuration: CGFloat = 0.25
            let length: CGFloat = (position - playerNode.position).length
            let arcToComponent = grenade.arcTo(position, speed: length / arcDuration)
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